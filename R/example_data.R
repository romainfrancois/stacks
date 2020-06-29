#' Example Data
#'
#' This package provides some workflow and resampling objects for use in examples
#' and tests. [lin_reg_res], [svm_res_], and [spline_res_] contain tuning results
#' for a linear regression, support vector machine, and spline model, respectively, 
#' fitting \code{body_mass_g} in the \code{palmerpenguins::penguins} data 
#' using all of the other variables as predictors. The source code for 
#' generating these objects is given below.
#' 
#' @examples 
#' \dontrun{
#' # setup: packages, data, resample, basic recipe ------------------------
#' library(tidymodels)
#' library(stacks)
#' data("penguins")
#' 
#' penguins <- penguins[!is.na(penguins$sex),]
#' 
#' set.seed(1)
#' 
#' ctrl_grid <- control_grid(save_pred = TRUE)
#' ctrl_res <- control_grid(save_pred = TRUE)
#' 
#' penguins_split <- initial_split(penguins)
#' penguins_train <- training(penguins_split)
#' penguins_test  <- testing(penguins_split)
#' 
#' folds <- vfold_cv(penguins_train, v = 5)
#' 
#' penguins_rec <- 
#'   recipe(body_mass_g ~ ., data = penguins_train) %>%
#'   step_dummy(all_nominal()) %>%
#'   step_zv(all_predictors())
#' 
#' metric <- metric_set(rmse)
#' 
#' # linear regression ---------------------------------------
#' lin_reg_spec <-
#'   linear_reg() %>%
#'   set_engine("lm")
#' 
#' lin_reg_wf_ <- 
#'   workflow() %>%
#'   add_model(lin_reg_spec) %>%
#'   add_recipe(penguins_rec)
#' 
#' lin_reg_res_ <- 
#'   fit_resamples(
#'     object = lin_reg_spec,
#'     preprocessor = penguins_rec,
#'     resamples = folds,
#'     metrics = metric,
#'     control = ctrl_res
#'   )
#' 
#' # support vector machine ----------------------------------
#' svm_spec <- 
#'   svm_rbf(
#'     cost = tune(), 
#'     rbf_sigma = tune()
#'   ) %>%
#'   set_engine("kernlab") %>%
#'   set_mode("regression")
#' 
#' svm_wf_ <- 
#'   workflow() %>%
#'   add_model(svm_spec) %>%
#'   add_recipe(penguins_rec)
#' 
#' svm_res_ <- 
#'   tune_grid(
#'     object = svm_spec, 
#'     preprocessor = penguins_rec, 
#'     resamples = folds, 
#'     grid = 5,
#'     control = ctrl_grid
#'   )
#' 
#' # spline regression ---------------------------------------
#' spline_rec <- 
#'   penguins_rec %>%
#'   step_ns(bill_length_mm, deg_free = tune::tune("length")) %>%
#'   step_ns(bill_depth_mm, deg_free = tune::tune("depth"))
#' 
#' spline_wf_ <- 
#'   workflow() %>%
#'   add_model(lin_reg_spec) %>%
#'   add_recipe(spline_rec)
#' 
#' spline_res_ <- 
#'   tune_grid(
#'     object = lin_reg_spec,
#'     preprocessor = spline_rec,
#'     resamples = folds,
#'     metrics = metric,
#'     control = ctrl_grid
#'   )
#' }
#' @name example_data
NULL

#' @rdname example_data
"svm_res_"

#' @rdname example_data
"spline_res_"