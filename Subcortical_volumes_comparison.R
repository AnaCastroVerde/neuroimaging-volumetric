
## After subcortical structures volume quantification was performed using
# a FSL bash script that combines FIRST (segmentation) and fslstats 
# (quantification), here we do statistical comparisons between patients (PAT)
# and HC at baseline (t0)


# Import packages ---------------------------------------------------------

library("ggplot2")
library("ggpubr")
library("rstatix")
library("car")

# Merge csv's ------------------------------------------------------------

setwd('/Users/Ana/volumetryfolder')
Subcortical_V_norm_t0 <- read.csv("Subcortical_Volumes_normalized_t0.csv",
                                  header = TRUE, sep =',')
Subcortical_V_norm_t1 <- read.csv("Subcortical_Volumes_Normalized_t1.csv",
                                  header = TRUE, sep =',')
Subcortical_V_norm_HC <- read.csv("Subcortical_Volumes_Normalized_HC.csv",
                                  header = TRUE, sep =',')

#Remove these 3 patients because treatment date was some days before baseline
Subcortical_V_norm_t0 <- Subcortical_V_norm_t0[c(-13,-28,-31),]
Subcortical_V_norm_t1 <- Subcortical_V_norm_t1[c(-13,-27,-30),]

Subcortical_V_norm <- rbind(Subcortical_V_norm_t0, Subcortical_V_norm_t1,
                            Subcortical_V_norm_HC)
head(Subcortical_V_norm)
colnames(Subcortical_V_norm)
nrow(Subcortical_V_norm)
summary(Subcortical_V_norm)

str(Subcortical_V_norm)


# Convert variables as factors --------------------------------------------

Subcortical_V_norm$Group <- factor(Subcortical_V_norm$Group, 
                       levels = c("ET", "CT", "HC"),
                       labels = c("PAT", "PAT", "HC"))
Subcortical_V_norm$Time <- factor(Subcortical_V_norm$Time, 
                                   levels = c("t0", "t1"))
Subcortical_V_norm$Case <- factor(Subcortical_V_norm$Case)

Subcortical_V_norm$Age <- c(47, 57, 43, 60, 48, 50, 55, 52, 49, 47, 53, 53, 67,
                            60, 55, 69, 57, 60, 50, 50, 63, 42, 68, 40, 49, 49,
                            59, 57, 57, 46, 45, 55, 49, 47, 57, 43, 60, 48, 50,
                            55, 52, 49, 47, 53, 53, 67, 60, 55, 69, 57, 60, 50,
                            50, 63, 42, 68, 49, 49, 59, 57, 57, 46, 45, 55, 49,
                            38, 41, 38, 34, 38, 52, 50, 45, 50, 52, 44, 48, 44,
                            51, 59, 59, 53, 43, 51, 49)

Sienax_volumes <- read.csv("NormalizedBrainVolume.csv",
                           header = TRUE, sep =',')
Sienax_volumes <- Sienax_volumes[c(-13,-28,-31,-49,-63,-66),]

Subcortical_V_norm$TotalBrainVolume <- Sienax_volumes$Normalized_Brain_Volume

View(Subcortical_V_norm)

#Frequency tables
table(Subcortical_V_norm$Time, Subcortical_V_norm$Group)

# Proportion method -------------------------------------------------------

Subcortical_V_norm$VLeft_Thalamus_t <- Subcortical_V_norm$VLeft_Thalamus/
  Subcortical_V_norm$TotalBrainVolume
Subcortical_V_norm$VLeft_Caudate_t <- Subcortical_V_norm$VLeft_Caudate/
  Subcortical_V_norm$TotalBrainVolume
Subcortical_V_norm$VLeft_Putamen_t <- Subcortical_V_norm$VLeft_Putamen/
  Subcortical_V_norm$TotalBrainVolume
Subcortical_V_norm$VLeft_Pallidum_t <- Subcortical_V_norm$VLeft_Pallidum/
  Subcortical_V_norm$TotalBrainVolume
Subcortical_V_norm$VLeft_Hippocampus_t <- Subcortical_V_norm$VLeft_Hippocampus/
  Subcortical_V_norm$TotalBrainVolume
Subcortical_V_norm$VLeft_Amygdala_t <- Subcortical_V_norm$VLeft_Amygdala/
  Subcortical_V_norm$TotalBrainVolume
Subcortical_V_norm$VLeft_Accumbens_t <- Subcortical_V_norm$VLeft_Accumbens/
  Subcortical_V_norm$TotalBrainVolume
Subcortical_V_norm$VRight_Thalamus_t <- Subcortical_V_norm$VRight_Thalamus/
  Subcortical_V_norm$TotalBrainVolume
Subcortical_V_norm$VRight_Caudate_t <- Subcortical_V_norm$VRight_Caudate/
  Subcortical_V_norm$TotalBrainVolume
Subcortical_V_norm$VRight_Putamen_t <- Subcortical_V_norm$VRight_Putamen/
  Subcortical_V_norm$TotalBrainVolume
Subcortical_V_norm$VRight_Pallidum_t <- Subcortical_V_norm$VRight_Pallidum/
  Subcortical_V_norm$TotalBrainVolume
Subcortical_V_norm$VRight_Hippocampus_t <- Subcortical_V_norm$VRight_Hippocampus/
  Subcortical_V_norm$TotalBrainVolume
Subcortical_V_norm$VRight_Amygdala_t <- Subcortical_V_norm$VRight_Amygdala/
  Subcortical_V_norm$TotalBrainVolume
Subcortical_V_norm$VRight_Accumbens_t <- Subcortical_V_norm$VRight_Accumbens/
  Subcortical_V_norm$TotalBrainVolume

# Boxplots for age, TBV and subcortical brain volumes --------------------------

age_comparison_bxp <- ggboxplot(Subcortical_V_norm, y="Age",
                                color="Group", palette = "blues")
        
TotalBrainVolume_comparison_bxp <- ggboxplot(Subcortical_V_norm, x="Time", 
                                             y="TotalBrainVolume", 
                                             color="Group", palette = "blues")

Subcortical_V_norm_baseline <- Subcortical_V_norm[Subcortical_V_norm$Time=="t0",]
#Show a random data sample
dplyr::sample_n(Subcortical_V_norm_baseline, 10)
Subcortical_V_norm_6months <- Subcortical_V_norm[Subcortical_V_norm$Time=="t1",]
#Re-order levels
Subcortical_V_norm_baseline <- Subcortical_V_norm_baseline %>% 
  reorder_levels(Group, order =c("HC", "PAT"))
levels(Subcortical_V_norm_baseline$Group)

a <- ggboxplot(Subcortical_V_norm, x="Group", y="VRight_Thalamus_t",
               color="Group",palette = "jco",
               order = c("HC", "PAT"),ylab = "R Thalamus Volume", )

b <- ggboxplot(Subcortical_V_norm_baseline, x="Group", y="VRight_Caudate_t",
               color="Group", palette = "jco",
               order = c("HC", "PAT"), ylab = "R Caudate Volume")

c <- ggboxplot(Subcortical_V_norm_baseline, x="Group", y="VRight_Putamen_t",
               color="Group", palette = "jco",
               order = c("HC", "PAT"), ylab = "R Putamen Volume")

d <- ggboxplot(Subcortical_V_norm_baseline, x="Group", y="VRight_Pallidum_t",
               color="Group", palette = "jco",
               order = c("HC", "PAT"), ylab = "R Pallidum Volume")

e <- ggboxplot(Subcortical_V_norm_baseline, x="Group", y="VRight_Amygdala_t",
               color="Group", palette = "jco",
               order = c("HC", "PAT"), ylab = "R Amygdala Volume")

f <- ggboxplot(Subcortical_V_norm_baseline, x="Group", y="VRight_Hippocampus_t",
               color="Group", palette = "jco",
               order = c("HC", "PAT"), ylab = "R Hippocampus Volume")

g <- ggboxplot(Subcortical_V_norm_baseline, x="Group", y="VRight_Accumbens_t",
               color="Group", palette = "jco",
               order = c("HC", "PAT"), ylab = "R Accumbens Volume")

h <- ggboxplot(Subcortical_V_norm_baseline, x="Group", y="VLeft_Thalamus_t",
               color="Group", palette = "jco",
               order = c("HC", "PAT"), ylab = "L Thalamus Volume")

i <- ggboxplot(Subcortical_V_norm_baseline, x="Group", y="VLeft_Caudate_t",
               color="Group", palette = "jco",
               order = c("HC", "PAT"), ylab = "L Caudate Volume")

j <- ggboxplot(Subcortical_V_norm_baseline, x="Group", y="VLeft_Putamen_t",
               color="Group", palette = "jco",
               order = c("HC", "PAT"), ylab = "L Putamen Volume")

k <- ggboxplot(Subcortical_V_norm_baseline, x="Group", y="VLeft_Pallidum_t",
               color="Group", palette = "jco",
               order = c("HC", "PAT"), ylab = "L Pallidum Volume")

l <- ggboxplot(Subcortical_V_norm_baseline, x="Group", y="VLeft_Amygdala_t",
               color="Group", palette = "jco",
               order = c("HC", "PAT"), ylab = "L Amygdala Volume")

m <- ggboxplot(Subcortical_V_norm_baseline, x="Group", y="VLeft_Hippocampus_t",
               color="Group", palette = "jco",
               order = c("HC", "PAT"), ylab = "L Hippocampus Volume")

n <-  ggboxplot(Subcortical_V_norm_baseline, x="Group", y="VLeft_Accumbens_t",
                color="Group", palette = "jco",
                order = c("HC", "PAT"), ylab = "L Accumbens Volume")

ggarrange(a, b, c, d, e, f, g, ncol = 3, nrow = 3)
ggarrange(h, i, j, k, l, m, n, ncol = 3, nrow = 3)

## Unpaired t-tests ------------------------------------------------------------

with(Subcortical_V_norm_baseline, shapiro.test(VRight_Thalamus_t)) # p > 0.05, so we can assume normality
var.test(Subcortical_V_norm_baseline$VRight_Thalamus_t[Subcortical_V_norm_baseline$Group == "HC"], Subcortical_V_norm_baseline$VRight_Thalamus_t[Subcortical_V_norm_baseline$Group == "PAT"]) # p > 0.05, so variances are equal
t_test_VRight_Thalamus <- t.test(VRight_Thalamus_t ~ Group, data = Subcortical_V_norm_baseline)
t_test_VRight_Thalamus$p.value <- p.adjust(t_test_VRight_Thalamus$p.value, method = "fdr")
t_test_VRight_Thalamus$p.value
t_test_VRight_Thalamus$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VRight_Caudate_t)) 
var.test(Subcortical_V_norm_baseline$VRight_Caudate_t[Subcortical_V_norm_baseline$Group == "HC"], Subcortical_V_norm_baseline$VRight_Caudate_t[Subcortical_V_norm_baseline$Group == "PAT"]) 
t_test_VRight_Caudate <- t.test(VRight_Caudate_t ~ Group,  data = Subcortical_V_norm_baseline)
t_test_VRight_Caudate$p.value <- p.adjust(t_test_VRight_Caudate$p.value, method = "fdr")
t_test_VRight_Caudate$p.value
t_test_VRight_Caudate$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VRight_Putamen_t)) 
var.test(Subcortical_V_norm_baseline$VRight_Putamen_t[Subcortical_V_norm_baseline$Group == "HC"], Subcortical_V_norm_baseline$VRight_Putamen_t[Subcortical_V_norm_baseline$Group == "PAT"]) 
t_test_VRight_Putamen <- t.test(VRight_Putamen_t ~ Group,  data = Subcortical_V_norm_baseline)
t_test_VRight_Putamen$p.value <- p.adjust(t_test_VRight_Putamen$p.value, method = "fdr")
t_test_VRight_Putamen$p.value
t_test_VRight_Putamen$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VRight_Pallidum_t)) 
var.test(Subcortical_V_norm_baseline$VRight_Pallidum_t[Subcortical_V_norm_baseline$Group == "HC"], Subcortical_V_norm_baseline$VRight_Pallidum_t[Subcortical_V_norm_baseline$Group == "PAT"]) 
t_test_VRight_Pallidum <- t.test(VRight_Pallidum_t ~ Group,  data = Subcortical_V_norm_baseline)
t_test_VRight_Pallidum$p.value <- p.adjust(t_test_VRight_Pallidum$p.value, method = "fdr")
t_test_VRight_Pallidum$p.value
t_test_VRight_Pallidum$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VRight_Amygdala_t)) 
var.test(Subcortical_V_norm_baseline$VRight_Amygdala_t[Subcortical_V_norm_baseline$Group == "HC"], Subcortical_V_norm_baseline$VRight_Amygdala_t[Subcortical_V_norm_baseline$Group == "PAT"]) 
t_test_VRight_Amygdala <- t.test(VRight_Amygdala_t ~ Group,  data = Subcortical_V_norm_baseline)
t_test_VRight_Amygdala$p.value <- p.adjust(t_test_VRight_Amygdala$p.value, method = "fdr")
t_test_VRight_Amygdala$p.value
t_test_VRight_Amygdala$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VRight_Hippocampus_t)) 
var.test(Subcortical_V_norm_baseline$VRight_Hippocampus_t[Subcortical_V_norm_baseline$Group == "HC"], Subcortical_V_norm_baseline$VRight_Hippocampus_t[Subcortical_V_norm_baseline$Group == "PAT"]) 
t_test_VRight_Hippocampus <- t.test(VRight_Hippocampus_t ~ Group,  data = Subcortical_V_norm_baseline)
t_test_VRight_Hippocampus$p.value <- p.adjust(t_test_VRight_Hippocampus$p.value, method = "fdr")
t_test_VRight_Hippocampus$p.value
t_test_VRight_Hippocampus$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VRight_Accumbens_t)) 
var.test(Subcortical_V_norm_baseline$VRight_Accumbens_t[Subcortical_V_norm_baseline$Group == "HC"], Subcortical_V_norm_baseline$VRight_Accumbens_t[Subcortical_V_norm_baseline$Group == "PAT"]) 
t_test_VRight_Accumbens <- t.test(VRight_Accumbens_t ~ Group,  data = Subcortical_V_norm_baseline)
t_test_VRight_Accumbens$p.value <- p.adjust(t_test_VRight_Accumbens$p.value, method = "fdr")
t_test_VRight_Accumbens$p.value
t_test_VRight_Accumbens$statistic

# Left side --------------------------------------------------------------------
with(Subcortical_V_norm_baseline, shapiro.test(VLeft_Thalamus_t)) # p > 0.05, so we can assume normality
var.test(Subcortical_V_norm_baseline$VLeft_Thalamus_t[Subcortical_V_norm_baseline$Group == "HC"], Subcortical_V_norm_baseline$VLeft_Thalamus_t[Subcortical_V_norm_baseline$Group == "PAT"]) # p > 0.05, so variances are equal
t_test_VLeft_Thalamus <- t.test(VLeft_Thalamus_t ~ Group,  data = Subcortical_V_norm_baseline)
t_test_VLeft_Thalamus$p.value <- p.adjust(t_test_VLeft_Thalamus$p.value, method = "fdr")
t_test_VLeft_Thalamus$p.value
t_test_VLeft_Thalamus$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VLeft_Caudate_t)) 
var.test(Subcortical_V_norm_baseline$VLeft_Caudate_t[Subcortical_V_norm_baseline$Group == "HC"], Subcortical_V_norm_baseline$VLeft_Caudate_t[Subcortical_V_norm_baseline$Group == "PAT"]) 
t_test_VLeft_Caudate <- t.test(VLeft_Caudate_t ~ Group,  data = Subcortical_V_norm_baseline)
t_test_VLeft_Caudate$p.value <- p.adjust(t_test_VLeft_Caudate$p.value, method = "fdr")
t_test_VLeft_Caudate$p.value
t_test_VLeft_Caudate$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VLeft_Putamen_t)) 
var.test(Subcortical_V_norm_baseline$VLeft_Putamen_t[Subcortical_V_norm_baseline$Group == "HC"], Subcortical_V_norm_baseline$VLeft_Putamen_t[Subcortical_V_norm_baseline$Group == "PAT"]) 
t_test_VLeft_Putamen <- t.test(VLeft_Putamen_t ~ Group,  data = Subcortical_V_norm_baseline)
t_test_VLeft_Putamen$p.value <- p.adjust(t_test_VLeft_Putamen$p.value, method = "fdr")
t_test_VLeft_Putamen$p.value
t_test_VLeft_Putamen$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VLeft_Pallidum_t)) 
var.test(Subcortical_V_norm_baseline$VLeft_Pallidum_t[Subcortical_V_norm_baseline$Group == "HC"], Subcortical_V_norm_baseline$VLeft_Pallidum_t[Subcortical_V_norm_baseline$Group == "PAT"]) 
t_test_VLeft_Pallidum <- t.test(VLeft_Pallidum_t ~ Group,  data = Subcortical_V_norm_baseline)
t_test_VLeft_Pallidum$p.value <- p.adjust(t_test_VLeft_Pallidum$p.value, method = "fdr")
t_test_VLeft_Pallidum$p.value
t_test_VLeft_Pallidum$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VLeft_Amygdala_t)) 
var.test(Subcortical_V_norm_baseline$VLeft_Amygdala_t[Subcortical_V_norm_baseline$Group == "HC"], Subcortical_V_norm_baseline$VLeft_Amygdala_t[Subcortical_V_norm_baseline$Group == "PAT"]) 
t_test_VLeft_Amygdala <- t.test(VLeft_Amygdala_t ~ Group,  data = Subcortical_V_norm_baseline)
t_test_VLeft_Amygdala$p.value <- p.adjust(t_test_VLeft_Amygdala$p.value, method = "fdr")
t_test_VLeft_Amygdala$p.value
t_test_VLeft_Amygdala$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VLeft_Hippocampus_t)) 
var.test(Subcortical_V_norm_baseline$VLeft_Hippocampus_t[Subcortical_V_norm_baseline$Group == "HC"], Subcortical_V_norm_baseline$VLeft_Hippocampus_t[Subcortical_V_norm_baseline$Group == "PAT"]) 
t_test_VLeft_Hippocampus <- t.test(VLeft_Hippocampus_t ~ Group,  data = Subcortical_V_norm_baseline)
t_test_VLeft_Hippocampus$p.value <- p.adjust(t_test_VLeft_Hippocampus$p.value, method = "fdr")
t_test_VLeft_Hippocampus$p.value
t_test_VLeft_Hippocampus$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VLeft_Accumbens_t)) # p < 0.05, so we cannot assume normality - let's do the Wilcoxon test
wilcox_test_VLeft_Accumbens <- wilcox.test(VLeft_Accumbens_t ~ Group,  data = Subcortical_V_norm_baseline)
wilcox_test_VLeft_Accumbens$p.value <- p.adjust(wilcox_test_VLeft_Accumbens$p.value, method = "fdr")
wilcox_test_VLeft_Accumbens$p.value
wilcox_test_VLeft_Accumbens$statistic


# ## After subcortical structures volume quantification was performed using
# a FSL bash script that combines FIRST (segmentation) and fslstats 
# (quantification), here we do statistical comparisons between patients (PAT)
# at baseline (t0) and 6 months after treatment (t1)

# Boxplots for subcortical brain volumes ---------------------------------------

a <- ggboxplot(Subcortical_V_norm, x="Time", y="VRight_Thalamus_t",
               color="Time",palette = "jco", ylab = "R Thalamus Volume")  #c("#00AFBB","#E7B800","#FC4E07")

b <- ggboxplot(Subcortical_V_norm, x="Time", y="VRight_Caudate_t",
               color="Time", palette = "jco",
               ylab = "R Caudate Volume")

c <- ggboxplot(Subcortical_V_norm, x="Time", y="VRight_Putamen_t",
               color="Time", palette = "jco",
               ylab = "R Putamen Volume")

d <- ggboxplot(Subcortical_V_norm, x="Time", y="VRight_Pallidum_t",
               color="Time", palette = "jco",
               ylab = "R Pallidum Volume")

e <- ggboxplot(Subcortical_V_norm, x="Time", y="VRight_Amygdala_t",
               color="Time", palette = "jco",
               ylab = "R Amygdala Volume")

f <- ggboxplot(Subcortical_V_norm, x="Time", y="VRight_Hippocampus_t",
               color="Time", palette = "jco",
               ylab = "R Hippocampus Volume")

g <- ggboxplot(Subcortical_V_norm, x="Time", y="VRight_Accumbens_t",
               color="Time", palette = "jco",
               ylab = "R Accumbens Volume")

h <- ggboxplot(Subcortical_V_norm, x="Time", y="VLeft_Thalamus_t",
               color="Time", palette = "jco",
               ylab = "L Thalamus Volume")  #c("#00AFBB","#E7B800","#FC4E07")

i <- ggboxplot(Subcortical_V_norm, x="Time", y="VLeft_Caudate_t",
               color="Time", palette = "jco",
               ylab = "L Caudate Volume")

j <- ggboxplot(Subcortical_V_norm, x="Time", y="VLeft_Putamen_t",
               color="Time", palette = "jco",
               ylab = "L Putamen Volume")

k <- ggboxplot(Subcortical_V_norm, x="Time", y="VLeft_Pallidum_t",
               color="Time", palette = "jco",
               ylab = "L Pallidum Volume")

l <- ggboxplot(Subcortical_V_norm, x="Time", y="VLeft_Amygdala_t",
               color="Time", palette = "jco",
               ylab = "L Amygdala Volume")

m <- ggboxplot(Subcortical_V_norm, x="Time", y="VLeft_Hippocampus_t",
               color="Time", palette = "jco",
               ylab = "L Hippocampus Volume")

n <-  ggboxplot(Subcortical_V_norm, x="Time", y="VLeft_Accumbens_t",
                color="Time", palette = "jco",
                ylab = "L Accumbens Volume")

ggarrange(a, b, c, d, e, f, g, ncol = 3, nrow = 3)
ggarrange(h, i, j, k, l, m, n, ncol = 3, nrow = 3)

Subcortical_V_norm_baseline <- Subcortical_V_norm_baseline[-24,]

## Paired t-tests --------------------------------------------------------------
with(Subcortical_V_norm_baseline, shapiro.test(VRight_Thalamus_t)) 
with(Subcortical_V_norm_6months, shapiro.test(VRight_Thalamus_t))
var.test(Subcortical_V_norm_baseline$VRight_Thalamus_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VRight_Thalamus_t[Subcortical_V_norm_6months$Group == "PAT"]) 
t_test_VRight_Thalamus_long <- t.test(Subcortical_V_norm_baseline$VRight_Thalamus_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VRight_Thalamus_t[Subcortical_V_norm_6months$Group == "PAT"], paired = TRUE)
t_test_VRight_Thalamus_long$p.value <- p.adjust(t_test_VRight_Thalamus_long$p.value, method = "fdr")
t_test_VRight_Thalamus_long$p.value
t_test_VRight_Thalamus_long$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VRight_Caudate_t)) 
with(Subcortical_V_norm_6months, shapiro.test(VRight_Caudate_t))
var.test(Subcortical_V_norm_baseline$VRight_Caudate_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VRight_Caudate_t[Subcortical_V_norm_6months$Group == "PAT"]) 
t_test_VRight_Caudate_long <- t.test(Subcortical_V_norm_baseline$VRight_Caudate_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VRight_Caudate_t[Subcortical_V_norm_6months$Group == "PAT"], paired = TRUE)
t_test_VRight_Caudate_long$p.value <- p.adjust(t_test_VRight_Caudate_long$p.value, method = "fdr")
t_test_VRight_Caudate_long$p.value
t_test_VRight_Caudate_long$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VRight_Putamen_t)) 
with(Subcortical_V_norm_6months, shapiro.test(VRight_Putamen_t))
wilcox_test_VRight_Putamen_long <- wilcox.test(Subcortical_V_norm_baseline$VRight_Putamen_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VRight_Putamen_t[Subcortical_V_norm_6months$Group == "PAT"], paired = TRUE)
wilcox_test_VRight_Putamen_long$p.value <- p.adjust(wilcox_test_VRight_Putamen_long$p.value, method = "fdr")
wilcox_test_VRight_Putamen_long$p.value
wilcox_test_VRight_Putamen_long$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VRight_Pallidum_t)) 
with(Subcortical_V_norm_6months, shapiro.test(VRight_Pallidum_t))
var.test(Subcortical_V_norm_baseline$VRight_Pallidum_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VRight_Pallidum_t[Subcortical_V_norm_6months$Group == "PAT"]) 
t_test_VRight_Pallidum_long <- t.test(Subcortical_V_norm_baseline$VRight_Pallidum_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VRight_Pallidum_t[Subcortical_V_norm_6months$Group == "PAT"], paired = TRUE)
t_test_VRight_Pallidum_long$p.value <- p.adjust(t_test_VRight_Pallidum_long$p.value, method = "fdr")
t_test_VRight_Pallidum_long$p.value
t_test_VRight_Pallidum_long$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VRight_Amygdala_t)) 
with(Subcortical_V_norm_6months, shapiro.test(VRight_Amygdala_t))
var.test(Subcortical_V_norm_baseline$VRight_Amygdala_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VRight_Amygdala_t[Subcortical_V_norm_6months$Group == "PAT"]) 
t_test_VRight_Amygdala_long <- t.test(Subcortical_V_norm_baseline$VRight_Amygdala_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VRight_Amygdala_t[Subcortical_V_norm_6months$Group == "PAT"], paired = TRUE)
t_test_VRight_Amygdala_long$p.value <- p.adjust(t_test_VRight_Amygdala_long$p.value, method = "fdr")
t_test_VRight_Amygdala_long$p.value
t_test_VRight_Amygdala_long$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VRight_Hippocampus_t)) 
with(Subcortical_V_norm_6months, shapiro.test(VRight_Hippocampus_t))
var.test(Subcortical_V_norm_baseline$VRight_Hippocampus_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VRight_Hippocampus_t[Subcortical_V_norm_6months$Group == "PAT"]) 
t_test_VRight_Hippocampus_long <- t.test(Subcortical_V_norm_baseline$VRight_Hippocampus_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VRight_Hippocampus_t[Subcortical_V_norm_6months$Group == "PAT"], paired = TRUE)
t_test_VRight_Hippocampus_long$p.value <- p.adjust(t_test_VRight_Hippocampus_long$p.value, method = "fdr")
t_test_VRight_Hippocampus_long$p.value
t_test_VRight_Hippocampus_long$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VRight_Accumbens_t)) 
with(Subcortical_V_norm_6months, shapiro.test(VRight_Accumbens_t))
var.test(Subcortical_V_norm_baseline$VRight_Accumbens_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VRight_Accumbens_t[Subcortical_V_norm_6months$Group == "PAT"]) 
t_test_VRight_Accumbens_long <- t.test(Subcortical_V_norm_baseline$VRight_Accumbens_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VRight_Accumbens_t[Subcortical_V_norm_6months$Group == "PAT"], paired = TRUE)
t_test_VRight_Accumbens_long$p.value <- p.adjust(t_test_VRight_Accumbens_long$p.value, method = "fdr")
t_test_VRight_Accumbens_long$p.value
t_test_VRight_Accumbens_long$statistic

# Left side --------------------------------------------------------------------

with(Subcortical_V_norm_baseline, shapiro.test(VLeft_Thalamus_t))
with(Subcortical_V_norm_6months, shapiro.test(VLeft_Thalamus_t))
var.test(Subcortical_V_norm_baseline$VLeft_Thalamus_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VLeft_Thalamus_t[Subcortical_V_norm_6months$Group == "PAT"]) 
wilcox_test_VLeft_Thalamus_long <- wilcox.test(Subcortical_V_norm_baseline$VLeft_Thalamus_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VLeft_Thalamus_t[Subcortical_V_norm_6months$Group == "PAT"], paired = TRUE)
wilcox_test_VLeft_Thalamus_long$p.value <- p.adjust(wilcox_test_VLeft_Thalamus_long$p.value, method = "fdr")
wilcox_test_VLeft_Thalamus_long$p.value
wilcox_test_VLeft_Thalamus_long$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VLeft_Caudate_t)) 
with(Subcortical_V_norm_6months, shapiro.test(VLeft_Caudate_t))
var.test(Subcortical_V_norm_baseline$VLeft_Caudate_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VLeft_Caudate_t[Subcortical_V_norm_6months$Group == "PAT"]) 
t_test_VLeft_Caudate_long <- t.test(Subcortical_V_norm_baseline$VLeft_Caudate_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VLeft_Caudate_t[Subcortical_V_norm_6months$Group == "PAT"], paired = TRUE)
t_test_VLeft_Caudate_long$p.value <- p.adjust(t_test_VLeft_Caudate_long$p.value, method = "fdr")
t_test_VLeft_Caudate_long$p.value
t_test_VLeft_Caudate_long$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VLeft_Putamen_t)) 
with(Subcortical_V_norm_6months, shapiro.test(VLeft_Putamen_t))
var.test(Subcortical_V_norm_baseline$VLeft_Putamen_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VLeft_Putamen_t[Subcortical_V_norm_6months$Group == "PAT"]) 
t_test_VLeft_Putamen_long <- t.test(Subcortical_V_norm_baseline$VLeft_Putamen_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VLeft_Putamen_t[Subcortical_V_norm_6months$Group == "PAT"], paired = TRUE)
t_test_VLeft_Putamen_long$p.value <- p.adjust(t_test_VLeft_Putamen_long$p.value, method = "fdr")
t_test_VLeft_Putamen_long$p.value
t_test_VLeft_Putamen_long$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VLeft_Pallidum_t)) 
with(Subcortical_V_norm_6months, shapiro.test(VLeft_Pallidum_t))
var.test(Subcortical_V_norm_baseline$VLeft_Pallidum_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VLeft_Pallidum_t[Subcortical_V_norm_6months$Group == "PAT"]) 
t_test_VLeft_Pallidum_long <- t.test(Subcortical_V_norm_baseline$VLeft_Pallidum_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VLeft_Pallidum_t[Subcortical_V_norm_6months$Group == "PAT"], paired = TRUE)
t_test_VLeft_Pallidum_long$p.value <- p.adjust(t_test_VLeft_Pallidum_long$p.value, method = "fdr")
t_test_VLeft_Pallidum_long$p.value
t_test_VLeft_Pallidum_long$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VLeft_Amygdala_t)) 
with(Subcortical_V_norm_6months, shapiro.test(VLeft_Amygdala_t))
var.test(Subcortical_V_norm_baseline$VLeft_Amygdala_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VLeft_Amygdala_t[Subcortical_V_norm_6months$Group == "PAT"]) 
t_test_VLeft_Amygdala_long <- t.test(Subcortical_V_norm_baseline$VLeft_Amygdala_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VLeft_Amygdala_t[Subcortical_V_norm_6months$Group == "PAT"], paired = TRUE)
t_test_VLeft_Amygdala_long$p.value <- p.adjust(t_test_VLeft_Amygdala_long$p.value, method = "fdr")
t_test_VLeft_Amygdala_long$p.value
t_test_VLeft_Amygdala_long$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VLeft_Hippocampus_t)) 
with(Subcortical_V_norm_6months, shapiro.test(VLeft_Hippocampus_t))
var.test(Subcortical_V_norm_baseline$VLeft_Hippocampus_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VLeft_Hippocampus_t[Subcortical_V_norm_6months$Group == "PAT"]) 
t_test_VLeft_Hippocampus_long <- t.test(Subcortical_V_norm_baseline$VLeft_Hippocampus_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VLeft_Hippocampus_t[Subcortical_V_norm_6months$Group == "PAT"], paired = TRUE)
t_test_VLeft_Hippocampus_long$p.value <- p.adjust(t_test_VLeft_Hippocampus_long$p.value, method = "fdr")
t_test_VLeft_Hippocampus_long$p.value
t_test_VLeft_Hippocampus_long$statistic

with(Subcortical_V_norm_baseline, shapiro.test(VLeft_Accumbens_t))
with(Subcortical_V_norm_6months, shapiro.test(VLeft_Accumbens_t))
var.test(Subcortical_V_norm_baseline$VLeft_Accumbens_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VLeft_Accumbens_t[Subcortical_V_norm_6months$Group == "PAT"]) 
wilcox_test_VLeft_Accumbens_long <- wilcox.test(Subcortical_V_norm_baseline$VLeft_Accumbens_t[Subcortical_V_norm_baseline$Group == "PAT"], Subcortical_V_norm_6months$VLeft_Accumbens_t[Subcortical_V_norm_6months$Group == "PAT"], paired = TRUE)
wilcox_test_VLeft_Accumbens_long$p.value <- p.adjust(wilcox_test_VLeft_Accumbens_long$p.value, method = "fdr")
wilcox_test_VLeft_Accumbens_long$p.value
wilcox_test_VLeft_Accumbens_long$statistic
