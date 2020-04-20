#Simulations for Cat, Dog, Bird----------------------------

initiate(Repeat_storage = F)
Process_Data(Data = Basic)
Process_Data(Data = Basic[which(Basic$Quality=="Affirmative"),])
Sim_data<-closest_vectors(composed = T,Sub = "Dogs",Pred = "?",Relation_set = c(1,1,1,2),Model = Model_Data)
Sim_data_cats<-closest_vectors(composed = T,Sub = "Cats",Pred = "?",Relation_set = c(1,1,1,2),Model = Model_Data)
Sim_data_birds<-closest_vectors(composed = T,Sub = "Birds",Pred = "?",Relation_set = c(1,1,1,2),Model = Model_Data)

for(i in 1:100){
  initiate(Repeat_storage = F,Normal_storage = F)
  Process_Data(Data = Basic[which(Basic$Quality=="Affirmative"),])
  Sim_data<-closest_vectors(composed = T,Sub = "Dogs",Pred = "?",Relation_set = c(1,1,1,2),Model = Model_Data)
  Sim_data_cats<-closest_vectors(composed = T,Sub = "Cats",Pred = "?",Relation_set = c(1,1,1,2),Model = Model_Data)
  Sim_data_birds<-closest_vectors(composed = T,Sub = "Birds",Pred = "?",Relation_set = c(1,1,1,2),Model = Model_Data)
  Angles<-c(Sim_data$`Model- 1 Similarity`[1:4], Sim_data_cats$`Model- 1 Similarity`[1:3], Sim_data_birds$`Model- 1 Similarity`[1:2])
  Animals<-c(rep("Dogs",4),rep("Cats",3),rep("Birds",2))
  if( i==1) {t<-data.frame(Animals,Angles)} else t<-rbind(t,data.frame(Animals,Angles))
}
CB=DB=DC=NULL
for(i in 1:100){
  initiate(Repeat_storage = F)
  Process_Data(Data = Basic)
  CB<-append(CB,cos(angle(Model_Data$`Model Number-1`$Concepts$Birds$Mem_Vector,Model_Data$`Model Number-1`$Concepts$Cats$Mem_Vector)[1]))
  DB<-append(DB,cos(angle(Model_Data$`Model Number-1`$Concepts$Birds$Mem_Vector,Model_Data$`Model Number-1`$Concepts$Dogs$Mem_Vector)[1]))
  DC<-append(DC,cos(angle(Model_Data$`Model Number-1`$Concepts$Dogs$Mem_Vector,Model_Data$`Model Number-1`$Concepts$Cats$Mem_Vector)[1]))
}
mean(CB);sd(CB)
mean(DB);sd(DB)
mean(DC);sd(DC)

f<-aov(Angles~Animals,data = t)soeon
summary(f)
TukeyHSD(f)

aggregate(Angles~Animals,data = t,FUN = mean)
aggregate(Angles~Animals,data = t,FUN = sd)
M_parameters<-All_Parameters[c(3,4)]
for(i in 1:100){
  initiate(Repeat_storage = F)
  Process_Data(Data = Basic[which(Basic$Quality=="Affirmative"),])
  Sim_data<-closest_vectors(composed = T,Sub = "Dogs",Pred = "?",Relation_set = c(1,1,1,2),Model = Model_Data)
  
  Angles<-c(Sim_data[which(Sim_data$`Model- 1 Concept`!="Dogs"),]$`Model- 1 Similarity`[1:4], Sim_data$`Model- 2 Similarity`[1:4])
  Models<-c(rep("Normalized",4),rep("Unnormalized",4))
  Arms<-c(paste("Arm",seq(1,4)),paste("Arm",seq(1,4)))
  if( i==1) {t<-data.frame(Models,Arms,Angles)} else t<-rbind(t,data.frame(Models,Arms,Angles))
}


f<-aov(Angles~Models*Arms,data = t)
summary(f)
TukeyHSD(f)

f<-aov(Angles~Models*Arms,data = t)

dp<-aggregate(Angles~Models+Arms,data = test,FUN = mean)
aggregate(Angles~Models*Arms,data = t,FUN = sd)


  