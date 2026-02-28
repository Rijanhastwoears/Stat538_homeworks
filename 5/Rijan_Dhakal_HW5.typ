#align(center)[
    = Rijan Dhakal
    = STAT 538
    == Homework 5
]

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
