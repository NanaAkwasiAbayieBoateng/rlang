% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cnd.R
\name{with_abort}
\alias{with_abort}
\title{Promote all errors to rlang errors}
\usage{
with_abort(expr)
}
\arguments{
\item{expr}{An expression run in a context where errors are
promoted to rlang errors.}
}
\description{
\code{with_abort()} promotes all errors as if they were thrown with
\code{\link[=abort]{abort()}}. These errors embed a \link[=trace_back]{backtrace}. They are
particularly suitable to be set as \emph{parent errors} (see \code{parent}
argument of \code{\link[=abort]{abort()}}).
}
\details{
\code{with_abort()} installs a \link[=calling]{calling handler} for errors and
rethrows non-rlang errors with \code{\link[=abort]{abort()}}. However, error handlers
installed \emph{within} \code{with_abort()} have priority. For this reason,
you should use \code{\link[=tryCatch]{tryCatch()}} and \link{exiting} handlers outside
\code{with_abort()} rather than inside.
}
\examples{
# For cleaner backtraces:
options(rlang_trace_top_env = current_env())

# with_abort() automatically casts simple errors thrown by stop()
# to rlang errors:
fn <- function() stop("Base error")
try(with_abort(fn()))
last_error()

# with_abort() is handy for rethrowing low level errors. The
# backtraces are then segmented between the low level and high
# level contexts.
low_level1 <- function() low_level2()
low_level2 <- function() stop("Low level error")

high_level <- function() {
  with_handlers(
    with_abort(low_level1()),
    error = ~ abort("High level error", parent = .x)
  )
}

try(high_level())
last_error()
summary(last_error())

# Reset to default
options(rlang_trace_top_env = NULL)
}
