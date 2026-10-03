# omnistats 0.1.0

* Initial release. Numerically robust building blocks for time-series
  analysis and financial backtesting:
  * `rolling_mean()` with `exact` (extended-precision, default) and
    `fast` (data.table) methods, verified against arbitrary-precision
    references (`Rmpfr`).
  * `to_returns()` for simple/log returns on vectors and `xts` objects.
  * `fit_linreg()` / `tidy_linreg()` — S3-wrapped linear models.
  * `validate_ohlcv()` — checkmate-based OHLCV data contract.
* Vignettes: getting started, backtesting hygiene.
