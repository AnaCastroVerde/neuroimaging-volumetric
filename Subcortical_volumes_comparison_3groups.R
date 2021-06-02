
## After subcortical structures volume quantification was performed using
# a FSL bash script that combines FIRST (segmentation) and fslstats 
# (quantification), here we do statistical comparisons between ET and CT
# patients and HC at two timepoints


# Import packages ---------------------------------------------------------

library("ggplot2")
library("ggpubr")
library("rstatix")
library("car")

# Merge csv's of 2 timepoints ---------------------------------------------

setwd('/Users/Ana/volumetryfolder')
Subcortical_V_norm_t0 <- read.csv("Subcortical_Volumes_normalized_t0.csv",
                                  header = TRUE, sep =',')
Subcortical_V_norm_t1 <- read.csv("Subcortical_Volumes_Normalized_t1.csv",
                                  header = TRUE, sep =',')
Subcortical_V_norm_HC <- read.csv("Subcortical_Volumes_Normalized_HC.csv",
                                  header = TRUE, sep =',')

Subcortical_V_norm <- rbind(Subcortical_V_norm_t0, Subcortical_V_norm_t1,
                            Subcortical_V_norm_HC)
head(Subcortical_V_norm)
colnames(Subcortical_V_norm)
nrow(Subcortical_V_norm)
summary(Subcortical_V_norm)

str(Subcortical_V_norm)


# Convert variables as factors --------------------------------------------

Subcortical_V_norm$Group <- factor(Subcortical_V_norm$Group, 
                       levels = c("ET", "CT", "HC"))
Subcortical_V_norm$Time <- factor(Subcortical_V_norm$Time, 
                                   levels = c("t0", "t1"))
Subcortical_V_norm$Case <- factor(Subcortical_V_norm$Case)

Subcortical_V_norm$Age <- c(rep(c(47, 57, 43, 60, 48, 50, 55, 52, 49, 47,
                                  53, 53, 48, 67, 60, 55, 69, 57, 60, 50,
                                  50, 63, 42, 68, 49, 49, 65, 59, 57, 65),2),
                            rep(c(55,52,48,58,65,47,46,67,63,49,60,47,47,52,
                                  65,54,49,60,55,58,59,50,68,45,46,58,69),2))

Sienax_volumes <- read.csv("NormalizedBrainVolume.csv",
                           header = TRUE, sep =',')

Subcortical_V_norm$TotalBrainVolume <- Sienax_volumes$Normalized_Brain_Volume

table(Subcortical_V_norm$Time, Subcortical_V_norm$Group) 


# Boxplots for age, TBV and subcortical brain volumes ---------------------

age_comparison_bxp <- ggboxplot(Subcortical_V_norm, y="Age",
                                color="Group", palette = "blues")
        
TotalBrainVolume_comparison_bxp <- ggboxplot(Subcortical_V_norm, x="Time", 
                                             y="TotalBrainVolume", 
                                             color="Group", palette = "blues")

bxp_L_Thalamus <- ggboxplot(Subcortical_V_norm, x="Time", y="VLeft_Thalamus",
                 color="Group", palette = "jco")
bxp_L_Caudate <- ggboxplot(Subcortical_V_norm, x="Time", y="VLeft_Caudate",
                           color="Group", palette = "jco")
bxp_L_Putamen <- ggboxplot(Subcortical_V_norm, x="Time", y="VLeft_Putamen",
                           color="Group", palette = "jco")
bxp_L_Pallidum <- ggboxplot(Subcortical_V_norm, x="Time", y="VLeft_Pallidum",
                           color="Group", palette = "jco")
bxp_L_Hippocampus <- ggboxplot(Subcortical_V_norm, x="Time", y="VLeft_Hippocampus",
                           color="Group", palette = "jco")
bxp_L_Amygdala <- ggboxplot(Subcortical_V_norm, x="Time", y="VLeft_Amygdala",
                               color="Group", palette = "jco")
bxp_L_Accumbens <- ggboxplot(Subcortical_V_norm, x="Time", y="VLeft_Accumbens",
                               color="Group", palette = "jco")
bxp_R_Thalamus <- ggboxplot(Subcortical_V_norm, x="Time", y="VRight_Thalamus",
                            color="Group", palette = "jco")
bxp_R_Caudate <- ggboxplot(Subcortical_V_norm, x="Time", y="VRight_Caudate",
                           color="Group", palette = "jco")
bxp_R_Putamen <- ggboxplot(Subcortical_V_norm, x="Time", y="VRight_Putamen",
                           color="Group", palette = "jco")
bxp_R_Pallidum <- ggboxplot(Subcortical_V_norm, x="Time", y="VRight_Pallidum",
                            color="Group", palette = "jco")
bxp_R_Hippocampus <- ggboxplot(Subcortical_V_norm, x="Time", y="VRight_Hippocampus",
                               color="Group", palette = "jco")
bxp_R_Amygdala <- ggboxplot(Subcortical_V_norm, x="Time", y="VRight_Amygdala",
                            color="Group", palette = "jco")
bxp_R_Accumbens <- ggboxplot(Subcortical_V_norm, x="Time", y="VRight_Accumbens",
                             color="Group", palette = "jco")
bxp_Brainstem <- ggboxplot(Subcortical_V_norm, x="Time", y="VBrainstem",
                               color="Group", palette = "jco")

# ANOVA considering time and treatment ------------------------------------
# Two-way ANOVA for unbalanced designs 
# using the recommended method of Type-III sum of squares 
# Hypothesis: 
# H0: There is no difference in the means of factor Treatment Group 
#(between-subjects)
# H1: There is no difference in the means of factor Time 
#(within-subjects)
# H2: There is no interaction between factors Treatment Group and Time

myanova_L_Thalamus <- aov(VLeft_Thalamus ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm) 
Anova(myanova_L_Thalamus, type = "III")
tukey.test1 <- tukey_hsd(aov(VLeft_Thalamus ~ Group * Time, data = Subcortical_V_norm))
tukey.test1$p.adj.fdr <-p.adjust(tukey.test1$p.adj,method = "fdr")
tukey.test1

myanova_L_Caudate <- aov(VLeft_Caudate ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm)
Anova(myanova_L_Caudate, type = "III")

myanova_L_Putamen <- aov(VLeft_Putamen ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm)
Anova(myanova_L_Putamen, type = "III")
tukey.test2 <- tukey_hsd(aov(VLeft_Putamen ~ Group * Time, data = Subcortical_V_norm))
tukey.test2$p.adj.fdr <-p.adjust(tukey.test2$p.adj,method = "fdr")
tukey.test2

myanova_L_Pallidum <- aov(VLeft_Pallidum ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm)
Anova(myanova_L_Pallidum, type = "III")

myanova_L_Hippocampus <- aov(VLeft_Hippocampus ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm)
Anova(myanova_L_Hippocampus, type = "III")

myanova_L_Amygdala <- aov(VLeft_Amygdala ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm)
Anova(myanova_L_Amygdala, type = "III")

myanova_L_Accumbens <- aov(VLeft_Accumbens ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm)
Anova(myanova_L_Accumbens, type = "III")
tukey.test3 <- tukey_hsd(aov(VLeft_Accumbens ~ Group * Time, data = Subcortical_V_norm))
tukey.test3$p.adj.fdr <-p.adjust(tukey.test3$p.adj,method = "fdr")
tukey.test3

myanova_R_Thalamus <- aov(VRight_Thalamus ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm)
Anova(myanova_R_Thalamus, type = "III")
tukey.test4 <- tukey_hsd(aov(VRight_Thalamus ~ Group * Time, data = Subcortical_V_norm))
tukey.test4$p.adj.fdr <-p.adjust(tukey.test4$p.adj,method = "fdr")
tukey.test4

myanova_R_Caudate <- aov(VRight_Caudate ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm) 
Anova(myanova_R_Caudate, type = "III")

myanova_R_Putamen <- aov(VRight_Putamen ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm)
Anova(myanova_R_Putamen, type = "III")
tukey.test5 <- tukey_hsd(aov(VRight_Putamen ~ Group * Time, data = Subcortical_V_norm))
tukey.test5$p.adj.fdr <-p.adjust(tukey.test5$p.adj,method = "fdr")
tukey.test5

myanova_R_Pallidum <- aov(VRight_Pallidum ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm)
Anova(myanova_R_Pallidum, type = "III")
tukey.test6 <- tukey_hsd(aov(VRight_Pallidum ~ Group * Time, data = Subcortical_V_norm))
tukey.test6$p.adj.fdr <-p.adjust(tukey.test6$p.adj,method = "fdr")
tukey.test6

myanova_R_Hippocampus <- aov(VRight_Hippocampus ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm)
Anova(myanova_R_Hippocampus, type = "III")

myanova_R_Amygdala <- aov(VRight_Amygdala ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm)
Anova(myanova_R_Amygdala, type = "III")

myanova_R_Accumbens <- aov(VRight_Accumbens ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm)
Anova(myanova_R_Accumbens, type = "III")
tukey.test7 <- tukey_hsd(aov(VRight_Accumbens ~ Group * Time, data = Subcortical_V_norm))
tukey.test7$p.adj.fdr <-p.adjust(tukey.test7$p.adj,method = "fdr")
tukey.test7

myanova_Brainstem <- aov(VBrainstem ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm)
Anova(myanova_Brainstem, type = "III")
tukey.test8 <- tukey_hsd(aov(VBrainstem ~ Group * Time, data = Subcortical_V_norm))
tukey.test8$p.adj.fdr <-p.adjust(tukey.test8$p.adj,method = "fdr")
tukey.test8

# Testing ANOVA assumptions -----------------------------------------------
#Homogeneity of variances if no evidence of relationships between residuals and fitted values
plot(myanova_L_Thalamus, 1)
leveneTest(VLeft_Thalamus ~ Group * Time + TotalBrainVolume, data = Subcortical_V_norm)
# Normality if the normal probability plot of residuals follow a straight line
plot(myanova_L_Thalamus, 2)
aov_residuals <- residuals(object = myanova_L_Thalamus)
shapiro.test(aov_residuals)
# Repeat for the other subcortical structures