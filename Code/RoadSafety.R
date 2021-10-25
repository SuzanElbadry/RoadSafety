library(data.table)
library(caret)
library(ggplot2)
library(dplyr)
library(rcompanion)
library(DescTools)
library(creditmodel)
library(corrplot)
library(rstudioapi)

current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(substr(current_path,1,rev(gregexpr("\\/", current_path)[[1]])[1]-1) ))
setwd(paste0(dirname(substr(current_path,1,rev(gregexpr("\\/", current_path)[[1]])[1]-1) ),"/Code"))
source("Functions.R")
setwd(paste0(dirname(substr(current_path,1,rev(gregexpr("\\/", current_path)[[1]])[1]-1) ),"/Data"))

Acc_DT_2020 <- fread("dft-road-casualty-statistics-accident-2020.csv")
Acc_DT_2019 <- fread("dft-road-casualty-statistics-accident-2019.csv")
Acc_DT_2018 <- fread("dft-road-casualty-statistics-accident-2018.csv")

Acc_DT <- rbind(Acc_DT_2018,Acc_DT_2019,Acc_DT_2020)
rm(Acc_DT_2018,Acc_DT_2019,Acc_DT_2020)

############################################################### Load reference Data ############################################################### 

Accident_Severity_DT <- fread("Accident_Severity.csv")
setnames(Accident_Severity_DT,old = c("label"),new = c("Accident_Severity"))

Day_of_Week_DT <- fread("Day_of_Week.csv")
setnames(Day_of_Week_DT,old = c("label"),new = c("Day_of_Week"))

Junction_Control_DT <- fread("Junction_Control.csv")
setnames(Junction_Control_DT,old = c("label"),new = c("Junction_Control"))

Junction_Detail_DT <- fread("Junction_Detail.csv")
setnames(Junction_Detail_DT,old = c("label"),new = c("Junction_Detail"))

Light_Conditions_DT <- fread("Light_Conditions.csv")
setnames(Light_Conditions_DT,old = c("label"),new = c("Light_Conditions"))

Local_Authority_District_DT <- fread("Local_Authority_District.csv")
setnames(Local_Authority_District_DT,old = c("label"),new = c("Local_Authority_District"))

Local_Authority_Highway_DT <- fread("Local_Authority_Highway.csv")
setnames(Local_Authority_Highway_DT,old = c("Label"),new = c("Local_Authority_Highway"))

Ped_Cross_Human_DT <- fread("Ped_Cross_Human.csv")
setnames(Ped_Cross_Human_DT,old = c("label"),new = c("Ped_Cross_Human"))

Ped_Cross_Physical_DT <- fread("Ped_Cross_Physical.csv")
setnames(Ped_Cross_Physical_DT,old = c("label"),new = c("Ped_Cross_Physical"))

Police_Force_DT <- fread("Police_Force.csv")
setnames(Police_Force_DT,old = c("label"),new = c("Police_Force"))

Police_Officer_Attend_DT <- fread("Police_Officer_Attend.csv")
setnames(Police_Officer_Attend_DT,old = c("label"),new = c("Police_Officer_Attend"))

Road_Class_DT <- fread("Road_Class.csv")
setnames(Road_Class_DT,old = c("label"),new = c("Road_Class"))

Road_Type_DT <- fread("Road_Type.csv")
setnames(Road_Type_DT,old = c("label"),new = c("Road_Type"))

Urban_Rural_DT <- fread("Urban_Rural.csv")
setnames(Urban_Rural_DT,old = c("label"),new = c("Urban_Rural"))
Urban_Rural_DT <- Urban_Rural_DT[code!=3]

############################################################### Join Reference tables to Accident Data table ############################################################### 

Acc_DT <- merge(Acc_DT,Accident_Severity_DT,by.x = c("accident_severity"),by.y = c("code"),all.x = TRUE)
Acc_DT$accident_severity <- NULL
Acc_DT$Accident_Severity <- as.factor(Acc_DT$Accident_Severity)

Acc_DT <- merge(Acc_DT,Day_of_Week_DT,by.x = c("day_of_week"),by.y = c("code"),all.x = TRUE)
Acc_DT$day_of_week <- NULL
Acc_DT$Day_of_Week <- as.factor(Acc_DT$Day_of_Week)

Acc_DT <- merge(Acc_DT,Junction_Control_DT,by.x = c("junction_control"),by.y = c("code"),all.x = TRUE)
Acc_DT$junction_control <- NULL
Acc_DT$Junction_Control <- as.factor(Acc_DT$Junction_Control)

Acc_DT <- merge(Acc_DT,Junction_Detail_DT,by.x = c("junction_detail"),by.y = c("code"),all.x = TRUE)
Acc_DT$junction_detail <- NULL
Acc_DT$Junction_Detail <- as.factor(Acc_DT$Junction_Detail)

Acc_DT <- merge(Acc_DT,Light_Conditions_DT,by.x = c("light_conditions"),by.y = c("code"),all.x = TRUE)
Acc_DT$light_conditions <- NULL
Acc_DT$Light_Conditions <- as.factor(Acc_DT$Light_Conditions)

Acc_DT <- merge(Acc_DT,Local_Authority_District_DT,by.x = c("local_authority_district"),by.y = c("code"),all.x = TRUE)
Acc_DT$local_authority_district <- NULL
Acc_DT$Local_Authority_District <- as.factor(Acc_DT$Local_Authority_District)

Acc_DT <- merge(Acc_DT,Local_Authority_Highway_DT,by.x = c("local_authority_highway"),by.y = c("Code"),all.x = TRUE)
Acc_DT$local_authority_highway <- NULL
Acc_DT$Local_Authority_Highway <- as.factor(Acc_DT$Local_Authority_Highway)


Acc_DT <- merge(Acc_DT,Ped_Cross_Human_DT,by.x = c("pedestrian_crossing_human_control"),by.y = c("code"),all.x = TRUE)
Acc_DT$pedestrian_crossing_human_control <- NULL
Acc_DT$Ped_Cross_Human <- as.factor(Acc_DT$Ped_Cross_Human)

Acc_DT <- merge(Acc_DT,Ped_Cross_Physical_DT,by.x = c("pedestrian_crossing_physical_facilities"),by.y = c("code"),all.x = TRUE)
Acc_DT$pedestrian_crossing_physical_facilities <- NULL
Acc_DT$Ped_Cross_Physical <- as.factor(Acc_DT$Ped_Cross_Physical)

Acc_DT <- merge(Acc_DT,Police_Force_DT,by.x = c("police_force"),by.y = c("code"),all.x = TRUE)
Acc_DT$police_force <- NULL
Acc_DT$Police_Force <- as.factor(Acc_DT$Police_Force)


Acc_DT <- merge(Acc_DT,Police_Officer_Attend_DT,by.x = c("did_police_officer_attend_scene_of_accident"),by.y = c("code"),all.x = TRUE)
Acc_DT$did_police_officer_attend_scene_of_accident <- NULL
Acc_DT$Police_Officer_Attend <- as.factor(Acc_DT$Police_Officer_Attend)


Acc_DT <- merge(Acc_DT,Road_Class_DT,by.x = c("first_road_class"),by.y = c("code"),all.x = TRUE)
Acc_DT$first_road_class <- NULL
setnames(Acc_DT,old=c("Road_Class"),new=c("First_Road_Class"))
Acc_DT$First_Road_Class <- as.factor(Acc_DT$First_Road_Class)

Acc_DT <- merge(Acc_DT,Road_Class_DT,by.x = c("second_road_class"),by.y = c("code"),all.x = TRUE)
Acc_DT$second_road_class <- NULL
setnames(Acc_DT,old=c("Road_Class"),new=c("Second_Road_Class"))
Acc_DT$Second_Road_Class <- as.factor(Acc_DT$Second_Road_Class)


Acc_DT <- merge(Acc_DT,Road_Type_DT,by.x = c("road_type"),by.y = c("code"),all.x = TRUE)
Acc_DT$road_type <- NULL
Acc_DT$Road_Type <- as.factor(Acc_DT$Road_Type)


Acc_DT <- merge(Acc_DT,Urban_Rural_DT,by.x = c("urban_or_rural_area"),by.y = c("code"),all.x = TRUE)
Acc_DT$urban_or_rural_area <- NULL
Acc_DT$Urban_Rural <- as.factor(Acc_DT$Urban_Rural)

rm(Accident_Severity_DT,Day_of_Week_DT,Junction_Control_DT,Junction_Detail_DT,Light_Conditions_DT,Local_Authority_District_DT,
   Local_Authority_Highway_DT,Ped_Cross_Human_DT,Ped_Cross_Physical_DT,Police_Force_DT,Police_Officer_Attend_DT,Road_Class_DT,Road_Type_DT,Urban_Rural_DT)

summary(Acc_DT)
#Remove Missing values
Acc_DT <- Acc_DT[complete.cases(Acc_DT), ]
#Preprocess features
Acc_DT <- Preprocess_Accidents(Acc_DT)

#write.csv(Acc_DT,"RoadSafety.csv",row.names = FALSE)
############################################################### Statistical Analysis ############################################################### 

TrainSet <- as.data.frame(Acc_DT[,c("Accident_Severity","speed_limit","Day_of_Week","Light_Conditions","Police_Officer_Attend","Urban_Rural","Road_Type","First_Road_Class","Hour_Bin",
                                    "Local_Authority_District","Local_Authority_Highway","number_of_casualties_bin","number_of_vehicles_bin","Junction_Control","Junction_Detail")])

#Generate CramerV correlation matrix
Corr_Mat <- char_cor(TrainSet)
corrplot(Corr_Mat, method = 'number',col= colorRampPalette(c("white","pink", "dodgerblue4"))(10),type="upper",tl.col="blue")

Significane_DT <- Chi_Sq_Test(TrainSet)

#Calculate variable interaction significance and correlation using Ch-Square test and CramerV
Significane_Interaction_DT <- Chi_Sq_Interact_Var_Test(TrainSet,GetallInteractions(TrainSet))

############################################################### Modelling  ############################################################### 

set.seed(42)
train <- sample(nrow(TrainSet), 0.8*nrow(TrainSet), replace = FALSE)
Trainingset <- TrainSet[train,]
ValidationSet <- TrainSet[-train,]

TrainSet_V1 <- as.data.frame(Trainingset[,c("Accident_Severity","speed_limit","Police_Officer_Attend","Urban_Rural","Hour_Bin","Day_of_Week","Road_Type",
                                         "number_of_casualties_bin","number_of_vehicles_bin","Junction_Control","Junction_Detail")])

#Random Forest Modelling
ctrl_Smote <- trainControl(sampling  = "smote")
mtry_V1 <- round(sqrt(ncol(TrainSet_V1)))
tunegrid_V1 <- expand.grid(.mtry=mtry)
model_smote_V1 <- train(Accident_Severity~., 
                     data=TrainSet_V1, 
                     method='rf', 
                     metric='Accuracy', 
                     tuneGrid=tunegrid, 
                     trControl=ctrl_Smote)
model_smote_V1
varimp_mars_V1 <- varImp(model_smote_V1)
plot(varimp_mars_V1, main="Variable Importance with MARS")

#Prediction
pred=predict(model_smote_V1, ValidationSet[,-1])
ConvMat_Smote_V1 <- confusionMatrix(pred,ValidationSet$Accident_Severity)
table <- data.frame(confusionMatrix(pred, ValidationSet$Accident_Severity)$table)
ggplot(data = plotTable, mapping = aes(x = Reference, y = Prediction, fill = goodbad)) +
  geom_tile() +
  geom_text(aes(label = Freq), vjust = .5, fontface  = "bold", alpha = 1) +
  scale_fill_manual(values = c(good = "lightblue", bad = "white")) +
  theme_bw() +
  xlim(rev(levels(table$Reference)))
