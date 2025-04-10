#!/usr/bin/env python3
# ==========================================================
# 📄 Script: time_engine.py
# 🧠 Zweck : Erweitert die Zeitdimension gemäß YAML (Rolling KPIs, Flags, Zeitvergleiche)
# 🔧 Version: 0.1.0
# ✏️ Status : draft
# 📅 Erstellt: 2025-04-11
# ==========================================================

import pandas as pd
import os
import numpy as np
from datetime import datetime
from core.engine.utils.yaml_loader import load_yaml

def enrich_calendar(df: pd.DataFrame, config: dict) -> pd.DataFrame:
    date_col = config["calendar"]["date_column"]

    df[date_col] = pd.to_datetime(df[date_col])
    df["year"] = df[date_col].dt.year
    df["month"] = df[date_col].dt.month
    df["month_name"] = df[date_col].dt.month_name()
    df["week"] = df[date_col].dt.isocalendar().week
    df["weekday"] = df[date_col].dt.weekday + 1  # 1 = Monday
    df["day_name"] = df[date_col].dt.day_name()
    df["quarter"] = df[date_col].dt.quarter

    df["is_weekend"] = df["weekday"].isin([6, 7])
    df["is_workday"] = ~df["is_weekend"]
    df["is_end_of_month"] = df[date_col] == df[date_col] + pd.offsets.MonthEnd(0)

    fiscal_start = config["calendar"].get("fiscal_year_start_month", 1)
    df["fiscal_year"] = df[date_col].apply(
        lambda x: x.year if x.month >= fiscal_start else x.year - 1
    )

    return df


def apply_rolling_metrics(df: pd.DataFrame, date_col: str, value_col: str, roll_cfgs: list) -> pd.DataFrame:
    df = df.sort_values(by=date_col)

    for rule in roll_cfgs:
        name = rule["name"]
        method = rule["type"]
        window = rule["window"]

        if method == "moving_average":
            df[name] = df[value_col].rolling(window=window).mean()
        elif method == "rolling_sum":
            df[name] = df[value_col].rolling(window=window).sum()
        else:
            print(f"⚠️ Unbekannte Roll-Methode: {method}")

    return df


def run_time_engine(yaml_path: str):
    config = load_yaml(yaml_path)
    input_path = config["output"]["enrich_table"]
    output_path = config["output"]["write_to"]
    calendar_conf = config.get("calendar", {})

    print(f"📅 Lade Zeitdimension: {input_path}")
    df = pd.read_parquet(input_path)

    df = enrich_calendar(df, config)

    if "rolling_windows" in config:
        val_col = config.get("analysis", {}).get("value_column", "value")
        df = apply_rolling_metrics(df, calendar_conf["date_column"], val_col, config["rolling_windows"])

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    df.to_parquet(output_path, index=False)
    print(f"✅ Zeitdimension erweitert gespeichert unter: {output_path}")
