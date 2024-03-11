# Project Dashboard Issue Fix

## Overview

This project addresses the issue of duplicate visits displayed on the web dashboard, where the same cleaner appears in multiple locations simultaneously. I've developed a solution that aggregates data, processes beacon signals, and accurately determines the location of cleaners within the facility.

## Problem Statement

In the current system, the web dashboard sometimes incorrectly displays a cleaner as being present in multiple locations at once. This is due to overlapping beacon signals and the high frequency of beacon pings, which can cause confusion and inaccuracies in tracking the real-time locations of the cleaning staff.

## Solution

To solve this problem, I have implemented a query that performs the following functions:

- **Data Aggregation**: The query aggregates data within one-minute intervals to process location signals more efficiently.

- **Signal Strength Analysis**: For each beacon ping (which occurs at roughly 15-second intervals), the query calculates the average signal strength.

- **Location Comparison and Selection**: The query compares the average signal strengths of beacon pings by the same user in different areas. It then selects the visit with the strongest average signal strength as the definitive 'cleaner visit' for the specified time period.

## Implementation Details

1. **Data Collection**: Beacon signals are collected in real-time, with a focus on ensuring that data from all relevant beacons is accurately captured.

2. **Query Execution**: The query is executed to process the collected data. This involves data aggregation by one-minute intervals and analysis of signal strength for each ping.

3. **Result Analysis**: After comparing signal strengths, the query identifies the location with the highest average signal strength for each cleaner within the specified timeframe.

4. **Dashboard Update**: The web dashboard is updated with the accurate locations of the cleaners, eliminating the issue of duplicate visits.

## Testing

The query has been thoroughly tested in an office environment to ensure its accuracy and reliability. Testing involved simulating various scenarios to challenge the query's ability to differentiate between closely located beacon signals and correctly identify the cleaner's location.

