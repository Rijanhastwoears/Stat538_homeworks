library(car)
library(svglite)

setwd("~/Repos/Stat538_homeworks/7")

# Load the dataset
pgatour <- read.csv("Data/pgatour2006.csv")

# Define the predictors
predictors <- c("DrivingAccuracy", "GIR", "PuttingAverage", 
                "BirdieConversion", "SandSaves", "Scrambling", "PuttsPerRound")
formula_untransformed <- as.formula(paste("PrizeMoney ~", paste(predictors, collapse = " + ")))
formula_log <- as.formula(paste("log(PrizeMoney) ~", paste(predictors, collapse = " + ")))

# Fit both models
fit_orig <- lm(formula_untransformed, data = pgatour)
fit_log  <- lm(formula_log, data = pgatour)

# Generate Diagnostic Plots
par(mfrow = c(2, 2))

# Model 1: Untransformed (Check for funnel shape in Resids vs Fitted and curve in Q-Q)
plot(fit_orig, which = 1, main = "Untransformed: Residuals vs Fitted")
plot(fit_orig, which = 2, main = "Untransformed: Normal Q-Q")

# Model 2: Log-transformed (Expect constant spread and straight Q-Q line)
plot(fit_log, which = 1, main = "Log-transformed: Residuals vs Fitted")
plot(fit_log, which = 2, main = "Log-transformed: Normal Q-Q")

# Fit the full model
full_model <- lm(log(PrizeMoney) ~ DrivingAccuracy + GIR + PuttingAverage + 
                   BirdieConversion + SandSaves + Scrambling + PuttsPerRound, data=pgatour)

# Diagnostic Plots
par(mfrow=c(2,2))
plot(full_model)

vif(full_model)


