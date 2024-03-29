% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hoeffding-tree-baritsu.R
\name{hoeffding_tree}
\alias{hoeffding_tree}
\alias{details_hoeffding_tree_baritsu}
\title{Hoeffding trees via baritsu}
\usage{
hoeffding_tree(
  mode = "classification",
  engine = "baritsu",
  confidence_factor = NULL,
  sample_size = NULL
)
}
\arguments{
\item{mode}{A single character string for the type of model.
The only possible value for this model is "classification".}

\item{engine}{A single character string specifying what computational engine
to use for fitting.}

\item{confidence_factor}{Confidence before splitting.}

\item{sample_size}{Number of passes to take over the dataset.}
}
\description{
\code{hoeffding_tree()} defines a Hoeffding tree model.
}
\details{
For this model, there is a single mode: classification
\subsection{Tuning Parameters}{

This model has 2 tuning parameters:
\itemize{
\item \code{confidence_factor}: Confidence before splitting (type: double)
\item \code{sample_size}: Number of passes to take over the dataset (type: int)
}
}
}
\seealso{
\code{\link[=hoeffding_trees]{hoeffding_trees()}}
}
\keyword{internal}
