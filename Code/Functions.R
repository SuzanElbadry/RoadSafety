
Preprocess_Accidents <- function(Acc_DT){
  
  Acc_DT <- as.data.table(Acc_DT)
  Acc_DT <- Acc_DT[speed_limit!=-1]
  
  #Bin Number of vehicles
  Acc_DT[,number_of_vehicles_bin:=as.character(number_of_vehicles)]
  Acc_DT[number_of_vehicles >2,number_of_vehicles_bin:=">2"]
  Acc_DT$number_of_vehicles_bin <- as.factor(Acc_DT$number_of_vehicles_bin)
  
  #Casualties Binning
  Acc_DT[,number_of_casualties_bin:=as.character(number_of_casualties)]
  Acc_DT[number_of_casualties >2,number_of_casualties_bin:=">2"]
  Acc_DT$number_of_casualties_bin <- as.factor(Acc_DT$number_of_casualties_bin)

  #Time
  Acc_DT[,Time_Hour:=substr(time,1,2)]
  Acc_DT$Hour_Bin <- "Morning Rush"
  Acc_DT[Time_Hour %in% c("10","11","12","13","14"),Hour_Bin:="Office hours"]
  Acc_DT[Time_Hour %in% c("15","16","17","18","19"),Hour_Bin:="Afternoon Rush"]
  Acc_DT[Time_Hour %in% c("20","21","22","23","23"),Hour_Bin:="Evening"]
  Acc_DT[Time_Hour %in% c("24","01","02","03","04","05"),Hour_Bin:="Night"]
  Acc_DT$Time_Hour <- NULL
  
  Acc_DT$speed_limit <- as.factor(Acc_DT$speed_limit)
  Acc_DT$Hour_Bin <- as.factor(Acc_DT$Hour_Bin)
  
  return(Acc_DT)
}

Chi_Sq_Test <- function(Acc_DT){
  
  Acc_DT <- TrainSet
  Acc_DT <- as.data.frame(Acc_DT)
  Idx <- 1
  Significane_DT <- data.table(
    Variable = colnames(Acc_DT)[-1],
    PValue = numeric(),
    cramer_Val = numeric(),
    Thiel_Val = numeric(),
    IsDependant = character()
  )
  
  for(i in 2:dim(Acc_DT)[2]){
    print(i)
    CTest <- chisq.test(Acc_DT[,1],Acc_DT[,i],correct = T)
    cramerVal <- cramerV(Acc_DT[,1],Acc_DT[,i],bias.correct = TRUE)
    Thiel <- UncertCoef(table(Acc_DT[,1],Acc_DT[,i]), direction = "column")
    
    Significane_DT[Idx,1] <- colnames(Acc_DT[i])
    Significane_DT[Idx,2] <- CTest$p.value
    Significane_DT[Idx,3] <- cramerVal
    Significane_DT[Idx,4] <- Thiel
    if(CTest$p.value <0.05){
      Significane_DT[Idx,5] <- "Dependant"}else{
        Significane_DT[Idx,5] <- "Independant"}
    Idx <- Idx+1
  }
  
  return(Significane_DT)
}

GetallInteractions <- function(Acc_DT){
  for(i in 2:(dim(Acc_DT)[2]-1)){
    if(i==2){
      Interaction_Var <- data.table(Variable1 = colnames(Acc_DT)[i],Variable2 = colnames(Acc_DT)[-(1:i)],PValue = numeric(),
                                    cramer_Val = numeric(),Thiel_Val = numeric(),
                                    IsDependant = character())}
    else{
      Interaction_Temp <- data.table(Variable1 = colnames(Acc_DT)[i],Variable2 = colnames(Acc_DT)[-(1:i)],PValue = numeric(),
                                    cramer_Val = numeric(),Thiel_Val = numeric(),
                                    IsDependant = character())
      Interaction_Var <- rbind(Interaction_Var,Interaction_Temp)
    }
  }
  return(Interaction_Var)
}

Chi_Sq_Interact_Var_Test <- function(Acc_DT,Interaction_Var_Dt){
  
  Acc_DT <- as.data.frame(Acc_DT)
  for(i in 1:(dim(Interaction_Var_Dt)[1])){
    print(i)
    
    Var1 <- Interaction_Var_Dt[i,1]$Variable1
    Var2 <- Interaction_Var_Dt[i,2]$Variable2
    
    CTest <- chisq.test(Acc_DT[,1],(Acc_DT[,c(Var1)]:Acc_DT[,c(Var2)]),correct = T)
    cramerVal <- cramerV(Acc_DT[,1],(Acc_DT[,c(Var1)]:Acc_DT[,c(Var2)]),bias.correct = TRUE)
    ThielVal <- UncertCoef(Acc_DT[,1],(Acc_DT[,c(Var1)]:Acc_DT[,c(Var2)]), direction = "column")
    
    Interaction_Var_Dt[i,3] <- CTest$p.value
    Interaction_Var_Dt[i,4] <- cramerVal
    Interaction_Var_Dt[i,5] <- ThielVal
    if(CTest$p.value <0.05){
      Interaction_Var_Dt[i,6] <- "Dependant"}else{
        Interaction_Var_Dt[i,6] <- "Independant"}
  }
  return(Interaction_Var_Dt)
}

