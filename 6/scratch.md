# Libraries and preamble


```R
install.packages("faraway")
install.packages("reshape2")
install.packages("Matching")
library(faraway)
library(tidyverse)
library(tidyr)
library(dplyr)
library(ggplot2)
library(reshape2)
```


```R
library(data.table)
```

# F4.2

## F4.2.a


```R
teengamb_base_lm <- lm (
    gamble ~ .,
    data = teengamb
)
```


```R
summary(teengamb_base_lm)
```


```R
head(teengamb)
```


```R
teengamb_male_average <- teengamb %>% 
    filter(sex == 0) %>%
    summarise(across(c(verbal, income, status), \(x) mean(x, na.rm = TRUE))) %>%
    as.data.frame()
```


```R
teengamb_male_average$sex = 0
```


```R
# Make predictions on new data X_test
teengamb_male_average_prediction <- 
    predict(
        teengamb_base_lm, 
        newdata = teengamb_male_average,
        interval = "prediction", 
        level = 0.95
)

```


```R
teengamb_male_average_prediction
```

Our prediction for the average male is 29.775 and the CI interval at 0.95 is (-16826, 76.37649) which is non sensible.

## F4.2.b


```R
teengamb_male_max <- teengamb %>% 
    summarise(across(everything(), max))
```


```R
teengamb_male_max_prediction <-
    predict(
        teengamb_base_lm, 
        newdata = teengamb_male_max,
        interval = "prediction", 
        level = 0.95
)
```


```R
teengamb_male_max_prediction
```

For males with the highest values in predictors, the dependent value is 49.1896120726776 and the CI at 0.95 is (-9.25, 107.63) which too is non-sensical.

## F4.2.c


```R
teengamb_sqrt_lm <- 
    lm(sqrt(gamble) ~ ., data = teengamb)
```


```R
summary(teengamb_sqrt_lm)
```

Note from the student: The question says 'The Individual' here is ambiguous. So, I will do it for both the average and the maximum case.

### The sqrt prediction for the teengamb male average is:


```R
teengamb_sqrt_male_max_prediction <-
    predict(
        teengamb_sqrt_lm, 
        newdata = teengamb_male_max,
        interval = "prediction", 
        level = 0.95
)
```


```R
teengamb_male_max_prediction
```

The predicted value of teengamb for a male with maximum predictors is 49.18. The CI intervals with 95% confidence are (-9.25,107.62) The negative is steill not the most sensible.

### The sqrt prediction for the teengamb male max is:


```R
teengamb_sqrt_male_average_prediction <-
    predict(
        teengamb_sqrt_lm, 
        newdata = teengamb_male_average,
        interval = "prediction", 
        level = 0.95
)
```


```R
teengamb_male_average_prediction
```

The predicted value of teengamb for a male with average predictors is 29.775. The CI intervals with 95% confidence are (-16.826, 76.376). The negative lower bound is not physically meaningful.

### F4.2.d


```R
teengamb_female_data_Frame <- 
    data.frame(
        sex = 1,
        income = 1,
        verbal = 10,
        status = 20
    )
```


```R
teengamb_female_sqrt_prediction <- 
    predict(
        teengamb_sqrt_lm, 
        newdata = teengamb_female_data_Frame,
        interval = "prediction",
        level = 0.95
    )
```


```R
teengamb_female_sqrt_prediction
```

The prediction with a negative value is not physically sensible. The upper bound is positive but the lower bound is negative.

# F4.3

## F4.3.a

(leaving this here for my own edification)

The 4 was what confused me, turns out that is just the count per group hard coded in.


```R
xtabs(water ~ temp + humid, snail)/4
```

We can also do the above as follows using the `tidyverse` api.


```R
snail %>%
  group_by(temp, humid) %>%
  summarize(mean_water = mean(water, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = humid, values_from = mean_water) %>% 
  fwrite("snail_temp_humidity_cross_tabulation.csv")
```

### Can I use the table to predict the water context for a temperature for *$25^{\circ}C$ *and a humidity of 60%?

Short answer: No.

The table represents is a discrete summary of the data at hand. It does address parts of the data in a modular way but that is not nearly enough to make predictions about the data at hand which is continuous in nature.

Maybe ...

I think my answer to this question is that this is something that can be done but also something that should not be done. The data is continuous and moreover wehave access to linear regression rather conviniently and we should use that instead. 


Back of the envelope calculations:

$25^{\circ}C$ is $20^{\circ}C$ + $30^{\circ}C$ divided by 2 perhaps the water content is somewhere between 72.5 and 69.5 or (69.5 + 72.5)/2 = 71

And 60% humiditity is 45 + 75 divided by 2 = 60, so perhaps the water content is somewhere between 72.5 and 81.50 or (72.5 + 81.5)/2 = 77.

And if we were to assign equal weight to temperature and humidity we get (71 + 77)/2 = 74.

Not saying this is scientific at all - just intuitive.

## 4.3.b


```R
water_content_lm <- lm(
    water ~ temp + humid,
    data = snail
)

summary(water_content_lm)
```


    
    Call:
    lm(formula = water ~ temp + humid, data = snail)
    
    Residuals:
        Min      1Q  Median      3Q     Max 
    -12.456  -2.915   1.461   3.613   8.749 
    
    Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
    (Intercept) 52.61081    6.85346   7.677 1.59e-07 ***
    temp        -0.18333    0.22645  -0.810    0.427    
    humid        0.47349    0.05036   9.403 5.63e-09 ***
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
    
    Residual standard error: 5.547 on 21 degrees of freedom
    Multiple R-squared:  0.8092,	Adjusted R-squared:  0.791 
    F-statistic: 44.53 on 2 and 21 DF,  p-value: 2.793e-08




```R
predict(
    water_content_lm,
    newdata = data.frame(
        temp = 25,
        humid = 60
    )
)
```


<strong>1:</strong> 76.4368131868132


The value comes out to be 76.4368131868132.

My back of the hand-calculations were 74 units and according to linear regression the answer is 76.436. A little off but not sure by how much.

## 4.3.c

Prediction for 30 degrees celcius and 75% humidity.


```R
predict(
    water_content_lm,
    newdata = data.frame(
        temp = 30,
        humid = 75
    )
)
```

The value comes out to be 82.622.

### Merits of the predictions for predictions from B and C i.e. the predictions that use the linear model

They use linear regression to make predictions about the continuous dependent variable which is the right thing to do.

## 4.3.d

By the definition of the linear model and its intercept, the intercept is the expected value of the response variable when all the predictors are equal to zero.

The (0,0) is not quite unique because there are any combinatinons of the predictor pairs that can cancel each other out.

## 4.3.e

The linear model evalutes to:

$\hat{y} = \beta_0 + \beta_1 x_1 + \beta_2 x_2 + \epsilon$

Where the relevant values are:

$\beta_0 = 52.6$

$\beta_1 = -0.18$

$\beta_2 = 0.47$

The question is bascially asking

humidity = (80 - 52.16 + 0.18 * 25 ) / 0.47

and the answer comes out to be 67.85.

Let's cross-verify with `predict()`.


```R
predict(
    water_content_lm,
    newdata = data.frame(temp = 25, humid = 67.85)
)
```

Which evaluated to `80.15`, I am a tad bit confused by the imprescision of the answer but it is close enough.

# F4.4

The `mdeaths` dataset .

## F4.4.a


```R
mdeaths_matrix <- matrix(data = mdeaths, nrow = 6, ncol = 12, byrow = TRUE)

colnames(mdeaths_matrix) <- month.name
rownames(mdeaths_matrix) <- seq(1974,1979, by = 1)

mdeaths_matrix
```


```R
# Convert matrix to long format
data_melt <- melt(mdeaths_matrix)
colnames(data_melt) <- c("Year", "Month", "Value")

# Ensure Year is treated correctly for labeling
years_present <- unique(data_melt$Year)

ggplot(data_melt, aes(x = Month, y = Year, fill = Value)) +
  geom_tile() +
  scale_fill_viridis_c(option = "magma") +
  # Force all years to appear on the axis
  scale_y_continuous(breaks = years_present) + 
  theme_bw() +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),
    aspect.ratio = 1,
    axis.title = element_text(face = "bold")
  ) +
  labs(x = "Month", y = "Year", fill = "Intensity")
```


```R
plot(mdeaths, 
     main = "Monthly Deaths from Lung Disease (UK Men, 1974-1979)",
     ylab = "Number of Deaths",
     xlab = "Year",
     col = "blue",
     lwd = 2)
```


```R
monthplot(mdeaths, 
          ylab = "Deaths", 
          main = "Seasonal Subseries Plot: mdeaths")
```

I struggle with visualziatin time series data. Given that there are two temporal dimensions (month and year), my first call was to make a heatmap. If you look at the heatmap, it looks like Febrary is the worst month of the time period that we are looking at.

If we look at something like `monthplot`, that concurs with the heatmap.

Just for fun, I also made a plot with the year on the y-axis and it seems the year 1976 was particularly atrocious.



## F4.4.b


```R
fit <- arima(mdeaths, order = c(1, 1, 0), seasonal = list(order = c(1, 1, 0), period = 12))

abs(fit$coef / sqrt(diag(fit$var.coef))) > 1.96
```


```R
# Extract coefficients and standard errors
coefs <- fit$coef
ses <- sqrt(diag(fit$var.coef))
z_stats <- abs(coefs / ses)

# Display results
data.frame(Estimate = coefs, Std_Error = ses, Z_Stat = z_stats, Significant = z_stats > 1.96)
```

It seems the seasonalilty is more important than the immediate priors.

## F4.4.c


```R
pred <- predict(fit, n.ahead = 2)
jan_pred <- pred$pred[1]
jan_se <- pred$se[1]
cat("Prediction:", jan_pred, "\n")
cat("95% PI:", jan_pred - 1.96 * jan_se, "to", jan_pred + 1.96 * jan_se)
```

Looks the possible number of deaths is 1851.967 with the PI at 0.95 is (1364.016 2339.918).

## F4.4.d


```R
feb_pred <- pred$pred[2]
feb_se <- pred$se[2]
cat("Prediction:", feb_pred, "\n")
cat("95% PI:", feb_pred - 1.96 * feb_se, "to", feb_pred + 1.96 * feb_se)
```

## F.4.4.e


```R
fitted_vals <- mdeaths - residuals(fit)
plot(as.vector(mdeaths), as.vector(fitted_vals), pch = 19, 
     xlab = "Observed", ylab = "Fitted", main = "Fitted vs Observed")
abline(0, 1, col = "red")
```


```R
# mdeaths is a time-series object (ts); convert to tibble
mdeaths_df <- tibble(
  deaths = as.numeric(mdeaths),
  month = factor(month.abb[cycle(mdeaths)], levels = month.abb)
)

# Calculate standard deviation per month
monthly_sd <- mdeaths_df %>%
  group_by(month) %>%
  summarize(std_dev = sd(deaths), .groups = "drop")
```


```R
monthly_sd
```


```R
ggplot(monthly_sd, aes(x = month, y = std_dev)) +
  geom_col() +
  labs(x = "Month", y = "Standard Deviation") +
  theme_minimal()
```


The accuracy of the predictions is unlikely to be same for all months. The standard deviation for the months are widely variable as seen the table and the figures above.

# F5.3

## F5.3.a

Here is the plot.

I used `ggplot2` to make this plot.


```R
# Convert sex to factor for discrete mapping
teengamb$sex_f <- factor(teengamb$sex, levels = c(0, 1), labels = c("Male", "Female"))

ggplot(teengamb, aes(x = income, y = gamble, color = sex_f, shape = sex_f)) +
  geom_point(size = 5) +
  scale_color_manual(values = c("Male" = "blue", "Female" = "red")) +
  scale_shape_manual(values = c("Male" = 1, "Female" = 19)) +
  labs(title = "Gamble vs Income by Sex",
       x = "income",
       y = "gamble",
       color = "Sex",
       shape = "Sex") +
  theme_bw()
```

## F5.3.b


```R
# Re-initialize plot to provide context for abline
plot(gamble ~ income, data = teengamb, 
     pch = ifelse(sex == 0, 1, 19), 
     col = ifelse(sex == 0, "blue", "red"),
     main = "Gamble vs Income with Regression Fits")

# Fit model
lmod <- lm(gamble ~ income + sex, data = teengamb)

# Extract coefficients
# Intercept is Male intercept; sex coefficient is the difference for Females
beta_0 <- coef(lmod)[1]
beta_income <- coef(lmod)[2]
beta_sex <- coef(lmod)[3]

# Plot lines
abline(a = beta_0, b = beta_income, col = "blue", lwd = 2)            # Male (sex=0)
abline(a = beta_0 + beta_sex, b = beta_income, col = "red", lwd = 2)  # Female (sex=1)

legend("topleft", legend = c("Male Fit", "Female Fit"), col = c("blue", "red"), lty = 1, lwd = 2)
```

## F5.3.c


```R
library(Matching)
# Treatment must be binary; here sex is already 0/1. 
# Matching on sex is trivial as it is the treatment; assuming match on income.
rr <- Match(Y = teengamb$gamble, Tr = teengamb$sex, X = teengamb$income, M = 1, replace = FALSE)
summary(rr)
```

Matched pairs: 19

Unmatched: 28 (Total n=47; 19 females matched to 19 of 28 males)

## F5.3.d


```R
plot(gamble ~ income, data = teengamb, 
     pch = ifelse(sex == 0, 1, 19), 
     col = ifelse(sex == 0, "blue", "red"))
index_m <- rr$index.control
index_f <- rr$index.treated
segments(teengamb$income[index_m], teengamb$gamble[index_m],
         teengamb$income[index_f], teengamb$gamble[index_f])
```

## F5.3.e


```R
diffs <- teengamb$gamble[index_f] - teengamb$gamble[index_m]
t.test(diffs)
```

It seems that the result is significant ($p = 0.02041$). Since $p < 0.05$, we reject the null hypothesis that the mean difference is zero.

## F5.3.f


```R
# Extract income from the treated (female) units that were matched
income_matched <- teengamb$income[rr$index.treated]

# Compute differences: Treated (Female) - Control (Male)
diffs <- teengamb$gamble[rr$index.treated] - teengamb$gamble[rr$index.control]

# Define color and shape based on which member of the pair gambled more
# Red if Female > Male (diffs > 0), Blue if Male > Female (diffs < 0)
pt_colors <- ifelse(diffs > 0, "red", "blue")
pt_shapes <- ifelse(diffs > 0, 19, 1)

plot(income_matched, diffs, 
     xlab = "Income", 
     ylab = "Gamble Difference (F - M)",
     pch = pt_shapes, 
     col = pt_colors,
     main = "Matched Pair Differences by Income")

# Add reference line at zero
abline(h = 0, lty = 2)

legend("bottomleft", 
       legend = c("Female Gambled More", "Male Gambled More"), 
       col = c("red", "blue"), 
       pch = c(19, 1),
       cex = 0.8)

# Proportion calculation
prop_female_more <- mean(diffs > 0)
prop_female_more
```

In about 15% of the matches, the women gambled more than the men.

## F5.3.g


```R
summary(lmod)
```


```R
t.test(diffs)
```

Both approaches agree that thee is a significant difference in gambling by gender. The results are significant in both cases. From the linear model, we see that the coefficient for gender is -21.634 and for the matched pairs the coefficient is -19.95 - slight disagreement but not by much.

More importantly, both are saying that men gamble more than women. 

# F5.4

## F5.4.a


```R
data(happy)
lmod_full <- lm(happy ~ money + sex + love + work, data = happy)
summary(lmod_full)
```

The love coefficient represents the expected change in the happy score for a one-unit increase in the love index (on its 1–3 scale), holding money, sex, and work constant.

## F5.4.b


```R
happy$clove <- ifelse(happy$love <= 2, 0, 1)
lmod_clove <- lm(happy ~ money + sex + clove + work, data = happy)
summary(lmod_clove)
```

The clove coefficient represents the estimated mean difference in happy score between students with a love score of 3 (clove = 1) and those with a score of 2 or less (clove = 0), adjusted for money, sex, and work. The results remain consistent in direction and significance, as the binary split captures the primary variance previously held in the 3-level ordinal scale.

## F5.4.c


```R
lmod_single <- lm(happy ~ clove, data = happy)
summary(lmod_single)
```

The coefficient is the difference in mean happy scores between the two clove groups. This value is higher than in the previous model because it now captures the effects of omitted variables (like money or work) that may be correlated with clove.

## F5.4.d


```R
ggplot(happy, aes(x = work, y = happy, shape = factor(clove), color = factor(clove))) +
  geom_jitter(width = 0.2, height = 0.2, size = 3) +
  scale_shape_manual(values = c(1, 19), name = "Clove") +
  scale_color_grey(start = 0.4, end = 0.2, name = "Clove") +
  theme_bw() +
  labs(
    title = "Relationship between Work and Happiness",
    subtitle = "Stratified by Clove status (0 = Low Love, 1 = High Love)",
    x = "Work Index",
    y = "Happiness Score"
  ) +
  theme(
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )
```

## F5.4.e


```R
xtabs(~ clove + work, happy)
```

Seems the answer is 14.

## F5.4.f


```R
# Calculate means per group
means_0 <- tapply(happy$happy[happy$clove == 0], happy$work[happy$clove == 0], mean)
means_1 <- tapply(happy$happy[happy$clove == 1], happy$work[happy$clove == 1], mean)

# Align indices to shared work levels (1, 2, 3, 4)
common_work <- intersect(names(means_0), names(means_1))
diffs <- means_1[common_work] - means_0[common_work]

# Resulting average difference
avg_diff <- mean(diffs)
print(avg_diff)
```

The average of these differences is most appropriately compared to the clove coefficient from the regression model in F5.4.b. Both methods attempt to estimate the effect of clove while controlling for the work covariate. The regression coefficient is a variance-weighted average of these strata-specific differences, whereas this calculation is a simple arithmetic average of the strata-specific differences.


```R

```
