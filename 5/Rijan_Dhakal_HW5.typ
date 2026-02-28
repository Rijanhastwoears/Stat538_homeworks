#align(center)[
    = Rijan Dhakal
    = STAT 538
    == Homework 5
]

// Grey out blocks
#show raw: it => {
  if it.block {
    rect(
      fill: luma(240),
      inset: 10pt,
      radius: 4pt,
      width: 100%,
      it
    )
  } else {
    it // Keep inline code as is
  }
}

#outline()

// Add a hyperlink to the table of contents on each page.
<toc>
#set page(footer: align(right, link(<toc>)[Table of Contents]))

= Preamble

The libararies I used throughout the workflow are

```R
library(tidyverse)
library(data.table)
library(faraway)
library(car)

```


= F3.2

== F3.2.a

The question is asking which of the fieldss in the cheddar dataset are statistically significant predictors of the dependent variable taste.

For This we can straightfowardly use the `lm()` function to fit a linear model and then use the `summary()` function to get the summary of the model.

```R
cheddar_linear_model <- lm(taste ~ Acetic + H2S + Lactic, data = cheddar)
summary(cheddar_linear_model)
```

Here is the output for `summary()`:

```text
Call:
lm(formula = taste ~ Acetic + H2S + Lactic, data = cheddar)

Residuals:
    Min      1Q  Median      3Q     Max
-17.390  -6.612  -1.009   4.908  25.449

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept) -28.8768    19.7354  -1.463  0.15540
Acetic        0.3277     4.4598   0.073  0.94198
H2S           3.9118     1.2484   3.133  0.00425 **
Lactic       19.6705     8.6291   2.280  0.03108 *
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 10.13 on 26 degrees of freedom
Multiple R-squared:  0.6518,	Adjusted R-squared:  0.6116
F-statistic: 16.22 on 3 and 26 DF,  p-value: 3.81e-06
```

Per the summary, the model is significantly better than an intercept only null model.

For the question of which predictors are significant, H2S and Lactic acid are significant at the 0.05 level.

#pagebreak()

== F3.2b

We can use the `exp()` function to remove the log transformation from the predictor values.

Here is the code for this

```R
# `chedar_log_removed` is a place holder. It will have the log-transformation removed in the next step.

cheddar_log_removed <- cheddar
cheddar_log_removed[,c("Acetic","H2S","Lactic") ]<- exp(cheddar_log_removed[,c("Acetic","H2S","Lactic")])
cheddar_log_removed_linear_model <- lm(taste ~ Acetic + H2S + Lactic, data = cheddar_log_removed)
summary(cheddar_log_removed_linear_model)
```

We get the following output for this
```
Call:
lm(formula = taste ~ Acetic + H2S + Lactic, data = cheddar_log_removed)

Residuals:
    Min      1Q  Median      3Q     Max
-15.862  -6.692  -1.583   5.661  27.006

Coefficients:
              Estimate Std. Error t value Pr(>|t|)
(Intercept) -8.6032212  7.7918800  -1.104  0.27965
Acetic       0.0199168  0.0153254   1.300  0.20515
H2S          0.0006458  0.0004359   1.482  0.15047
Lactic       5.8178200  2.0653455   2.817  0.00914 **
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 11.13 on 26 degrees of freedom
Multiple R-squared:  0.5794,	Adjusted R-squared:  0.5309
F-statistic: 11.94 on 3 and 26 DF,  p-value: 4.209e-05
```

Per the summary of the model with the log scale removed, the model itself is still significantly better than the null model or one of the independent variables does reduce the mean square error.

Without the log scale, only the Lactic acid content is a significant predictor of the taste score.

#pagebreak()

== F3.2.c

This question has two parts.

=== Can the two models be compared using an F-test?
Short answer: No.

We can use linear model's F-statistic to compare a linear model with predictors against the null model that has the intercept only. Extending that idea, we can use the partial F-test to compare models where one model is simple, linear and nested subset of the other model that is "complex" but still linear. For our answer, we want to compare a model that is on the log scale to a model that is on the original scale. The log scale is not a nested linear transformation of the original scale. As such we cannot use the partial F-test to compare the two models.

=== Which model provides a better fit to the data?

Short answer: The model on the log scale.

The log-scale model has a R-squared of 0.6518 where the original scale model has a R-squared of 0.5794.

#pagebreak()

== F3.3.d

The Estimated Regression Coefficnet for H2S is 3.9118. So , for every unit increase in H2S, the taste score is expected to increase by 3.9118. Which means for an increase of 0.01 in H2S, the taste score is expected to increase by 0.01*3.9118 = 0.039118

#pagebreak()

== F3.2.e

Note from the student: Note sure if the the expectation was to do this in R or if plan pseducode is enough.

This should be a percent incerease of `exp(.01)`

The relevant code:

```
f32e_answer = ((exp(.01) - 1 ) * 100)
print(f32e_answer)
```

So, the value is 1.005017 %.

#pagebreak()

= F3.4

== F3.4.a

Here is the code for this:

```R
sat_linear_model <- lm(total ~ expend + ratio + salary, data = sat)
summary(sat_linear_model)
```

The output for the above code is:

```txt
Call:
lm(formula = total ~ expend + ratio + salary, data = sat)

Residuals:
     Min       1Q   Median       3Q      Max
-140.911  -46.740   -7.535   47.966  123.329

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept) 1069.234    110.925   9.639 1.29e-12 ***
expend        16.469     22.050   0.747   0.4589
ratio          6.330      6.542   0.968   0.3383
salary        -8.823      4.697  -1.878   0.0667 .
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 68.65 on 46 degrees of freedom
Multiple R-squared:  0.2096,	Adjusted R-squared:  0.1581
F-statistic: 4.066 on 3 and 46 DF,  p-value: 0.01209
```

=== Hypothesis: βSalary = 0

While the coefficient is non-zero, it is not significant at the 5% level. So, we fail to reject the null hypothesis.

=== Hypothesis: βSalary = βRatio = βExpend = 0

The F-test is significant at the 5% level. So, we reject the null hypothesis i.e. the model is a better fit than the null model that used only the intercept without any predictors.

== F3.2.b

Testing the model with takes included.

```R
sat_takers_linear_model <- lm(total ~ expend + ratio + salary + takers, data = sat)
summary(sat_takers_linear_model)
```

The output for above is

```txt
Call:
lm(formula = total ~ expend + ratio + salary + takers, data = sat)

Residuals:
    Min      1Q  Median      3Q     Max
-90.531 -20.855  -1.746  15.979  66.571

Coefficients:
             Estimate Std. Error t value Pr(>|t|)
(Intercept) 1045.9715    52.8698  19.784  < 2e-16 ***
expend         4.4626    10.5465   0.423    0.674
ratio         -3.6242     3.2154  -1.127    0.266
salary         1.6379     2.3872   0.686    0.496
takers        -2.9045     0.2313 -12.559 2.61e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 32.7 on 45 degrees of freedom
Multiple R-squared:  0.8246,	Adjusted R-squared:  0.809
F-statistic: 52.88 on 4 and 45 DF,  p-value: < 2.2e-16
```

Hypothesis: βtakers = 0

The coefficient for βtakers with -2.9045 is significant at the 5% level. So, we reject the null hypothesis.

Compare the model to the previous model

`anova(sat_linear_model, sat_takers_linear_model)`

#let data = csv("data/3.4/sat_linear_vs_sat_takers.csv")

#table(
  columns: data.first().len(),
  // Iterate through rows and cells
  ..data.flatten()
)

=== Simple vs. Complex Model
Per the anova() output, the complex model does explain more variance than the simple model.

=== Is the partial F-test a T-test?
The only difference between the simple model and the complex model is that of a single predictor i.e. "the takers". In effect, the partial F-test has asked the question does "Does the takers as a predictor explain a significant amount of variance in the dependent variable?".

So, witihin this context, the partial F-test is a T-test and also F = t#super[2].

#pagebreak()

= F3.5

== Derivation of F-statistic from $R^2$

Given a linear regression model:
$y = X beta + epsilon$

With $n$ observations and $k$ predictors (excluding intercept).

=== 1. Definitions

$R^2$ is defined as the proportion of total variance explained by the model:
$R^2 = ("SSR") / ("SST") = 1 - ("SSE") / ("SST")$

The F-statistic tests the overall significance of the model ($H_0: beta_1 = ... = beta_k = 0$):
$F = ("MSR") / ("MSE") = ("SSR" / k) / ("SSE" / (n - k - 1))$

=== 2. Manipulation

From the $R^2$ definition, we can express the Sum of Squares Residual ($"SSE"$) in terms of $R^2$ and Sum of Squares Total ($"SST"$):
$"SSE" = "SST" (1 - R^2)$

Similarly, the Sum of Squares Regression ($"SSR"$) is:
$"SSR" = "SST" R^2$

=== 3. Substitution

Substitute $"SSR"$ and $"SSE"$ into the F-statistic formula:

$F = ("SSR" / k) / ("SSE" / (n - k - 1))$

The $"SST"$ terms cancel out:

$F = (R^2 / k) / ((1 - R^2) / (n - k - 1))$

Rearranging for the final formula:

$F = (R^2 (n - k - 1)) / (k (1 - R^2))$


#pagebreak()

= F3.6

== F3.6.a

The code for this is:

```R
happy_linear_model <- lm(happy ~ money + sex + love + work, data = happy)

# change the significance level to 1%
confint(happy_linear_model, level = 0.99)
```
The table is as follows:

#let data = csv("data/3.6/happy_linear_model_1_percent.csv")

#table(
  columns: data.first().len(),
  // Iterate through rows and cells
  ..data.flatten()
)

For the full summary, `summary(happy_linear_model)`

```txt
Call:
lm(formula = happy ~ money + sex + love + work, data = happy)

Residuals:
    Min      1Q  Median      3Q     Max
-2.7186 -0.5779 -0.1172  0.6340  2.0651

Coefficients:
             Estimate Std. Error t value Pr(>|t|)
(Intercept) -0.072081   0.852543  -0.085   0.9331
money        0.009578   0.005213   1.837   0.0749 .
sex         -0.149008   0.418525  -0.356   0.7240
love         1.919279   0.295451   6.496 1.97e-07 ***
work         0.476079   0.199389   2.388   0.0227 *
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 1.058 on 34 degrees of freedom
Multiple R-squared:  0.7102,	Adjusted R-squared:  0.6761
F-statistic: 20.83 on 4 and 34 DF,  p-value: 9.364e-09
```

==== Which predictors are significant at the 1% level?

`summary(happy_linear_model)$coefficients[, "Pr(>|t|)"] < 0.01`

```txt
(Intercept): FALSE
money: FALSE
sex: FALSE
love: TRUE
work: FALSE
```

Seems the only predictor that is significant at the 1% level is Love.

== F3.6.b

The code for this is:

`tabel(happy$happy)`

```
2  3  4  5  6  7  8  9 10
1  1  4  5  2  8 14  3  1
 ```

Seems the data is not normally distributed.

`shapiro.test(happy$happy)`

```
Shapiro-Wilk normality test

data:  happy$happy
W = 0.90355, p-value = 0.002793
```

We can confirm with the `shapiro.test()` function that the data is not normally distributed.


== F3.6.c

Here is the code that I used for this question

```R
# Setup
set.seed(42)
B <- 500000
obs_model <- lm(happy ~ money + sex + love + work, data = happy)
t_obs <- summary(obs_model)$coefficients["money", "t value"]

# Permutation Loop
t_null <- replicate(B, {
  happy$money_perm <- sample(happy$money)
  perm_model <- lm(happy ~ money_perm + sex + love + work, data = happy)
  summary(perm_model)$coefficients["money_perm", "t value"]
})

# Two-tailed p-value calculation
p_perm <- mean(abs(t_null) >= abs(t_obs))

# Visualization
hist(t_null, breaks = 50, main = "Null Distribution of t-values",
     xlab = "Permuted t-statistics", xlim = range(c(t_null, t_obs)))
abline(v = t_obs, col = "red", lwd = 2, lty = 2)

cat("Observed t:", t_obs, "\n")
cat("Permutation p-value (B =", B, "):", p_perm, "\n")
```

#pagebreak()

== F3.6.d

The image comes out as follows:

#figure(
    image("images/t_null_hist.svg"),
    caption : "Null Distribution of t-values when permuted 500,000 times."
)

Per the statistics from the permutation test, the p-value is 0.07. As such we fail to reject the null hypothesis. The money predictor does not have a significant effect on the depedence variable (happyness).

#pagebreak()

== F3.6.e

Note from the student: Is this not what we did for F3.6.d?

Anyways, here is how I would do this.

Histogram for the permutation of the t-statistic and density.

#figure(
    image("images/t_null_density.svg"),
    caption: "The null distribution with the density graph."
)

== F3.6.f

This is very easy to do with the `boot` library.

```R
library(boot)

# Function to return the money coefficient
boot_fn <- function(data, indices) {
  model <- lm(happy ~ money + sex + love + work, data = data[indices, ])
  return(coef(model)["money"])
}

# Execute bootstrap
boot_results <- boot(data = happy, statistic = boot_fn, R = 2000)

# Calculate intervals (Normal, Basic, Percentile, BCa) for 90% and 95%
boot.ci(boot_results, conf = c(0.90, 0.95), type = c("norm", "basic", "perc", "bca"))
```

The output came out as:

```txt
BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
Based on 2000 bootstrap replicates

CALL :
boot.ci(boot.out = boot_results, conf = c(0.9, 0.95), type = c("norm",
    "basic", "perc", "bca"))

Intervals :
Level      Normal              Basic
90%   (-0.0020,  0.0193 )   (-0.0027,  0.0170 )
95%   (-0.0041,  0.0213 )   (-0.0082,  0.0188 )

Level     Percentile            BCa
90%   ( 0.0022,  0.0218 )   ( 0.0021,  0.0213 )
95%   ( 0.0003,  0.0274 )   ( 0.0002,  0.0263 )
Calculations and Intervals on Original Scale
```

==== Does the confidence interval include 0?
Per the `boot()` function in R and the `*BCA*` based bootstrap it looks like 0 is not included in either the 90% and 95% confidence intervals.

==== What does the confidence interval say about the previous tests?

The Linear Model predict the coefficient to be 0.009578 but at a significance of 0.07 against a threshold of 0.05. Where the Boostrap has predicted the intervals to be significant at a threshold of 0.05 or 5% with a consistently postiitive impact.

#pagebreak()

= F3.7

```R
punting_linear_model <- lm(Distance ~ RStr + LStr + RFlex + LFlex, data = punting)
summary(punting_linear_model)
```

```txt
Call:
lm(formula = Distance ~ RStr + LStr + RFlex + LFlex, data = punting)

Residuals:
    Min      1Q  Median      3Q     Max
-23.941  -8.958  -4.441  13.523  17.016

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept) -79.6236    65.5935  -1.214    0.259
RStr          0.5116     0.4856   1.054    0.323
LStr         -0.1862     0.5130  -0.363    0.726
RFlex         2.3745     1.4374   1.652    0.137
LFlex        -0.5277     0.8255  -0.639    0.541

Residual standard error: 16.33 on 8 degrees of freedom
Multiple R-squared:  0.7365,	Adjusted R-squared:  0.6047
F-statistic:  5.59 on 4 and 8 DF,  p-value: 0.01902
```

== F3.7.a

Seems like none of the predictors are significant at the 5% level.

== F3.7.b

Per the `lm()` model, the F-statistic is 5.59 and is significant at the 0.05 level.

== F3.7.c

I used `linearHypotesis()` function

```R
install.packages("car")
library(car)
linearHypothesis(punting_linear_model, "RStr = LStr")
```

The output comes out as:

#let data = csv("data/3.7/RStr_vs_LStr.csv")

#table(
  columns: data.first().len(),
  // Iterate through rows and cells
  ..data.flatten()
)

With a P-value of 0.468, we fail to reject the null hypothesis i.e. the Right-strenght and the Left-strength are equal.

== F3.5.d

```R
#Plot the 95% confidence ellipse for the two strength coefficients
confidenceEllipse(punting_linear_model, which.coeff = c("RStr", "LStr"), levels = 0.95)
```
Here is what the plot looks like:

#figure(
    image("images/residuals_plot.png"),
    caption: "95% Confidence Ellipse for Strength Coefficients"
)

Looks like the confidence intervals do agree with the assesment from C with (0,0) being in the 95% CI.

== F3.7.e

```R
# Reduced Model (Testing if Total Strength is sufficient)
punting_total_strenght_linear_model <- lm(Distance ~ I(RStr + LStr) + RFlex + LFlex, data = punting)

# Partial F-test
anova(punting_total_strenght_linear_model, punting_linear_model)
```

#let data = csv("data/3.7/anova_punting_total_vs_granular.csv")

#table(
  columns: data.first().len(),
  // Iterate through rows and cells
  ..data.flatten()
)

Our null hypothesis is that total Strength is the same as using a granular right strength, left strenght. Given that out P-value is not less than 0.05, we fail to reject the null hypothesis. So, seems we can just use the total strength.

== F3.7.f
I used the `car` package's `linearHypothesis()` function to perform the linear hypothesis test.

```R
linearHypothesis(punting_linear_model, "RFlex = LFlex")
```

#let data = csv("data/3.7/punting_linear_model.csv")

#table(
  columns: data.first().len(),
  // Iterate through rows and cells
  ..data.flatten()
)


With a P-value of 0.201we fail to reject the null hypothesis i.e. the Right-flex the Left-flex are equal in terms of effect.

== F3.7.g

```R
# Full Model: 4 predictors
fm <- lm(Distance ~ RStr + LStr + RFlex + LFlex, data = punting)

# Symmetry Model: 2 predictors (Total Strength and Total Flexibility)
# This model assumes side-to-side symmetry
sm <- lm(Distance ~ I(RStr + LStr) + I(RFlex + LFlex), data = punting)

# Partial F-test for Symmetry
anova(sm, fm)
```

#let data = csv("data/3.7/sm_vs_fm.csv")

#table(
  columns: data.first().len(),
  // Iterate through rows and cells
  ..data.flatten()
)

For the null hypothesis that Right and Left parts of the system have similar impact, we have a P-value of 0.336. It seems like the null hypothesis is not rejected and the two parts of the system have similar impact.

== F3.7.h

```R
punting_hang_linear_model <- lm(Hang ~ RStr + LStr + RFlex + LFlex, data = punting)
anova(punting_linear_model, punting_hang_linear_model)

Warning message in anova.lmlist(object, ...):
“models with response ‘"Hang"’ removed because response differs from model 1”
```
As the warning message states, we can but should not compare the two models. The predictors are shared but the dependent is not. As such, comparision in not valid.

(Here is the table anyways)

#let data = csv("data/3.7/punt_vs_hang.csv")

#table(
  columns: data.first().len(),
  // Iterate through rows and cells
  ..data.flatten()
)
