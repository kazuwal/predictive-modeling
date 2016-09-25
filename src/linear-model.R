iris_df <- iris
library(plyr)
library(dplyr)

wide_ficticios_data <- 
data.frame(
 Y = c(2,3,4,6,7,8,10,11,12),
 G1 = c(2,3,4,100,101,102,103,104,105),
 G2 = c(106,107,108,6,7,8,109,110,111),
 G3 = c(112,113,114,115,116,117,10,11,12)
)

long_ficticious_data <-
  melt(wide_ficticios_data,
       id.vars = c("Y"), variable.name = "G_variable", value.name = "G_value"
)

long_ficticious_data <- 
  filter(long_ficticious_data, Y == G_value
)


dummy_var_cond <-
    function(g_variable) {
      as.numeric(
        (long_ficticious_data$Y == long_ficticious_data$G_value) & 
        (as.character(long_ficticious_data$G_variable) == g_variable)
      )
    }

dummy_df <- 
  data.frame(
    Y = wide_ficticios_data$Y,
    dummy_1 = dummy_var_cond("G1"),
    dummy_2 = dummy_var_cond("G2"),
    dummy_3 = dummy_var_cond("G3")
  )

