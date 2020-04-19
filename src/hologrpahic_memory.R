#Holographic Memory 

#Initialize holographic memory
initiate<-function(){
  Model_Data<<-list()
  for(i in 1:nrow(All_models)){
    Model_Number=i
    Parameters=All_models[i,,drop=F]
    Concepts=list()
    Cardinals=list()
    t<-list(Model_Number,Parameters,Concepts,Cardinals)
    names(t)=c("Model_Number","Parameters","Concepts", "Cardinals")
    y=list(t)
    names(y)=paste("Model Number-",i,sep = "")
    Model_Data<<-append(Model_Data,y)
  }
  #Create a List of all the Cardinals
  for (i in Categories_data$Type){
    Cat<-i
    add_concept(x = i,Type = "Cardinal" )
  }
}

process_data <- function(Data) {
  for (i in 1:nrow(Data)) {
    relate_main(
      Sub = Data$Subject[i],
      Pred = Data$Predicate[i],
      Quantity = Data$Quantity[i],
      Quality = Data$Quality[i],
      Relation = Data$Relation[i],
      Modality = Data$Modality[i],
      Prop_name = Data$Details[i]
    )
  }
}


#Get enviormental vector for a concept
Env<-function(x){
  if(x %in% names(Concepts)){
    return(Concepts[[x]][["Env"]])
  }else{
    paste("Concept does not exist")
  }
}

#Initialize a concept--------------------
add_concept<-function(x,Type="Concept"){
  
  Vects <- list(vect(), vect())
  names(Vects) <- c("Mem_Vector", "Env_Vector")
  
  for (i in 1:length(Model_Data)) {
    
    if (Type != "Cardinal") {
      
      New_Concept <- list(Vects)
      names(New_Concept) <- x
      Model_Data[[i]][["Concepts"]] <<-
        append(Model_Data[[i]][["Concepts"]], New_Concept)
      
    } else {
      
      New_Cardinal <- list(Vects)
      names(New_Cardinal) <- x
      Model_Data[[i]][["Cardinals"]] <<-
        append(Model_Data[[i]][["Cardinals"]], New_Cardinal)
    }
  }
}

#List all concepts--------------------
list_concepts<-function(){
  return(names(Model_Data$`Model Number-1`$Concepts))
}

# Relate subject and predicate concept with each other and strore the resulting compoite
### Relating has defaults for quick testing
relate_main<-function(Sub,
                      Pred,
                      Quantity = 1,
                      Quality = 1,
                      Relation = 1,
                      Modality = 2,
                      singlerun = F,
                      Prop_name = "?") {
  
  
  if (Prop_name == "?") {
    Prop_name = paste(Sub, Cardinals$Quality[Quality], Cardinals$Relation[Relation], Pred)
  }
  
  #Getting vectors for  Cardinals-----------------------
  
  if(is.numeric(Quantity)==T){
    Quantity <- Cardinals$Quantity[[Quantity]]
    Quality <- Cardinals$Quality[[Quality]]
    Relation <- Cardinals$Relation[[Relation]]
    Modality <- Cardinals$Modality[[Modality]]
  }
  #Add constituents concepts if not already existent------------------------
  if (!Sub %in% names(Model_Data[[1]][["Concepts"]])) {
    add_concept(x = Sub)
  }
  if (!Pred %in% names(Model_Data[[1]][["Concepts"]])) {
    add_concept(x = Pred)
  }
  
  #Create New Concept from the Relation-----------------------
  if (!Prop_name %in% names(Model_Data[[1]][["Concepts"]])) {
    add_concept(x = Prop_name)
    Repeated_information = FALSE
  } else {
    Repeated_information = TRUE
  }
  
  # Encoding information in accorance to various models----------------------
  for (i in 1:length(Model_Data)) {
    Model_changes <- list()
    Parameters <-
      Model_Data[[i]]$Parameters
    Model_changes <- append(Model_changes, Parameters)
    
    #Decide if repeated information should be encoded-------------------------
    Encode_Flag = TRUE
    if (Repeated_information == T) {
      Encode_Flag = FALSE
      if ("Repeatable_Storage" %in% names(Parameters)) {
        if (Parameters$Repeatable_Storage == "yes")
          Encode_Flag = TRUE
      }
    }
    
    #Initialize metrics for later reporting----------------
    sub_MV = Model_Data[[i]][["Concepts"]][[Sub]][["Mem_Vector"]]
    pred_MV = Model_Data[[i]][["Concepts"]][[Pred]][["Mem_Vector"]]
    
    Change_SubMV <- NA
    New_sub_MV <- NA
    Rel_CV <- NA
    Change_PredMV <- NA
    New_pred_MV <- NA
    #Encoding----------------------------
    if(Encode_Flag==TRUE){
      #Get concept and Cardinal vectors----------------------------------------------------------
      
      sub_EV = Model_Data[[i]][["Concepts"]][[Sub]][["Env_Vector"]]
      pred_EV = Model_Data[[i]][["Concepts"]][[Pred]][["Env_Vector"]]
      
      Quantity_Card_EV <- Model_Data[[i]][["Cardinals"]][[Quantity]][["Env_Vector"]]
      Quantity_Card_MV <- Model_Data[[i]][["Cardinals"]][[Quantity]][["Mem_Vector"]]
      Quality_Card_EV <-  Model_Data[[i]][["Cardinals"]][[Quality]][["Env_Vector"]]
      Quality_Card_MV <-  Model_Data[[i]][["Cardinals"]][[Quality]][["Mem_Vector"]]
      Relation_Card_EV <- Model_Data[[i]][["Cardinals"]][[Relation]][["Env_Vector"]]
      Relation_Card_MV <- Model_Data[[i]][["Cardinals"]][[Relation]][["Mem_Vector"]]
      Modality_Card_EV <- Model_Data[[i]][["Cardinals"]][[Modality]][["Env_Vector"]]
      Modality_Card_MV <- Model_Data[[i]][["Cardinals"]][[Modality]][["Mem_Vector"]]
      
      #Parameter based encoding--------------------------------------------------
      
      if ("Normalize_conv" %in% names(Parameters)) {
        Normalize_conv = Parameters$Normalize_conv == "yes"
      } else {
        Normalize_conv = FALSE
      }
      
      if ("Normalize_store" %in% names(Parameters)) {
        Normalize_store = Parameters$Normalize_store == "yes"
      } else {
        Normalize_store = FALSE
      }
      
      #Creating a Relation Vector form Env Vectors of cardinal vectors-----------
      Rel_CV = convol(
        x = convol(
          x = convol(x = Quantity_Card_EV,
                     y = Quality_Card_EV),
          y = Relation_Card_EV
        ),
        y = Modality_Card_EV,
        norm = T
      )
      
      if ("Priority_only" %in% names(Parameters)) {
        if (Parameters$Priority_only == "yes") {
          Rel_CV = convol(x =  Quality_Card_EV, y = Relation_Card_EV, norm = T)
        }
      }
      
      #Convolution and Addition to Subject Memory---------------------------
      Change_SubMV <-
        convol(
          x = convol(x = Rel_CV, y =  Placeholder, norm = Normalize_conv),
          y = pred_EV,
          norm = Normalize_conv
        )
      New_sub_MV = normalize_vec(sub_MV + Change_SubMV, Disable = !Normalize_store)
      
      # Convolution and Addition to Predicate Memory
      Change_PredMV <-
        convol(
          x = convol(x = Rel_CV, y = sub_EV, norm = Normalize_conv),
          y = Placeholder,
          norm = Normalize_conv
        )
      New_pred_MV = normalize_vec(pred_MV + Change_PredMV, Disable = !Normalize_store)
      
      #Env and Mem Vectors for New Concept------------------------
      t <-
        convol(
          x = convol(x = sub_EV, y = Rel_CV, norm = Normalize_conv),
          y = pred_EV,
          norm = Normalize_conv
        )
      New_concept_MV = normalize_vec(x = t)
      #Mem Vectors for Cardinals------------------------
      t <- convol(x = sub_EV, y = pred_EV, norm = Normalize_conv)
      Addition_Cardinal_Mem <- t
      
      #Update Vectors--------------------------------
      
      New_sub_MV ->> Model_Data[[i]][["Concepts"]][[Sub]][["Mem_Vector"]]
      New_pred_MV ->> Model_Data[[i]][["Concepts"]][[Pred]][["Mem_Vector"]]
      
      #Parameter Based Updating of Proposition Vector
      if (Repeated_information == T) {
        Model_Data[[i]][["Concepts"]][[Prop_name]][["Mem_Vector"]] + New_concept_MV ->>
          Model_Data[[i]][["Concepts"]][[Prop_name]][["Mem_Vector"]]
      } else{
        New_concept_MV ->> Model_Data[[i]][["Concepts"]][[Prop_name]][["Mem_Vector"]]
        New_concept_MV ->> Model_Data[[i]][["Concepts"]][[Prop_name]][["Env_Vector"]]
      }
      
      #updating Memory vectors for cardinals-------------
      normalize_vec(Addition_Cardinal_Mem + Quality_Card_MV,
                    Disable = !Normalize_store) ->> Model_Data[[i]][["Cardinals"]][[Quality]][["Mem_Vector"]]
      normalize_vec(Addition_Cardinal_Mem + Relation_Card_MV,
                    Disable = !Normalize_store) ->> Model_Data[[i]][["Cardinals"]][[Relation]][["Mem_Vector"]]
      normalize_vec(Addition_Cardinal_Mem + Modality_Card_MV,
                    Disable = !Normalize_store) ->> Model_Data[[i]][["Cardinals"]][[Modality]][["Mem_Vector"]]
      normalize_vec(Addition_Cardinal_Mem + Quantity_Card_MV,
                    Disable = !Normalize_store) ->> Model_Data[[i]][["Cardinals"]][[Quantity]][["Mem_Vector"]]
    }
    #Creating change log for singlre run-------------------------
    if (singlerun == T) {
      d <- data.frame(Model = paste("Model", i))
      d$Subject = Sub
      d$sub_MV = list(sub_MV)
      d$Change_SubMV = list(Change_SubMV)
      d$New_sub_MV = list(New_sub_MV)
      d$Rel_CV = list(Rel_CV)
      
      d$Pred = Pred
      d$pred_MV = list(pred_MV)
      d$Change_PredMV = list(Change_PredMV)
      d$New_pred_MV = list(New_pred_MV)
      if (i == 1)
        (Changes <- d)else(Changes<-rbind(Changes,d))
    }
  }
  if (singlerun == T) {
    return (Changes)
  }
}

closest_vector_model <-
  function(composed = F,
           Sub = "?" ,
           Pred = "?",
           Relation_set = "?",
           Model) {
    angles <- NULL
    Parameters = Model$Parameters
    
    if ("Normalize_conv" %in% names(Parameters)) {
      Normalize_conv = Parameters$Normalize_conv == "yes"
    } else {
      Normalize_conv = FALSE
    }
    
    #Get actual cardinals--------------------------------------
    if (Relation_set != "?") {
      Quantity <- Cardinals$Quantity[[Relation_set[1]]]
      Quality <- Cardinals$Quality[[Relation_set[2]]]
      Relation <- Cardinals$Relation[[Relation_set[3]]]
      Modality <- Cardinals$Modality[[Relation_set[4]]]
    }
    #Differntiated Query for composed or not composed
    if (composed == F) {
      x = Model$Concepts[[Sub]][["Mem_Vector"]]
      for (i in 1:length(Model$Concepts)) {
        t <- angle(x = x , y = Model$Concepts[[i]][["Mem_Vector"]])
        angles <- append(angles, t["Angle_in_Radian"])
      }
      f_angles <-
        data.frame(Concept = names(Model$Concepts),
                   Similarity = cos(angles))
      f_angles <- f_angles[order(f_angles$Similarity, decreasing = T), ]
    } else {
      #Getting vectors--------------------------
      sub_EV = Model[["Concepts"]][[Sub]][["Env_Vector"]]
      sub_MV = Model[["Concepts"]][[Sub]][["Mem_Vector"]]
      pred_EV = Model[["Concepts"]][[Pred]][["Env_Vector"]]
      pred_MV = Model[["Concepts"]][[Pred]][["Mem_Vector"]]
      
      Quantity_Card_EV <-
        Model[["Cardinals"]][[Quantity]][["Env_Vector"]]
      Quantity_Card_MV <-
        Model[["Cardinals"]][[Quantity]][["Mem_Vector"]]
      Quality_Card_EV <- Model[["Cardinals"]][[Quality]][["Env_Vector"]]
      Quality_Card_MV <- Model[["Cardinals"]][[Quality]][["Mem_Vector"]]
      Relation_Card_EV <-
        Model[["Cardinals"]][[Relation]][["Env_Vector"]]
      Relation_Card_MV <-
        Model[["Cardinals"]][[Relation]][["Mem_Vector"]]
      Modality_Card_EV <-
        Model[["Cardinals"]][[Modality]][["Env_Vector"]]
      Modality_Card_MV <-
        Model[["Cardinals"]][[Modality]][["Mem_Vector"]]
      
      #Query vector creation--------------
      if (Relation_set != "?") {
        Rel_CV = convol(
          x = convol(
            x = convol(x = Quantity_Card_EV,
                       y = Quality_Card_EV),
            y = Relation_Card_EV
          ),
          y = Modality_Card_EV,
          norm = T
        )
        
        if ("Priority_only" %in% names(Parameters)) {
          if (Parameters$Priority_only == "yes") {
            Rel_CV = convol(x =  Quality_Card_EV,
                            y = Relation_Card_EV,
                            norm = T)
          }
        }
        for (i in 1:length(Model$Concepts)) {
          if (Pred == "?") {
            x = sub_MV
            y <-
              convol(
                x = convol(
                  x = Rel_CV,
                  y = Placeholder,
                  norm = Normalize_conv
                ),
                y = Model[["Concepts"]][[i]][["Env_Vector"]] ,
                norm = Normalize_conv
              )
          } else if (Sub == "?") {
            x = pred_MV
            y <-
              convol(
                x = convol(
                  x = Rel_CV,
                  y =  Model[["Concepts"]][[i]][["Env_Vector"]],
                  norm = Normalize_conv
                ),
                y = Placeholder,
                norm = Normalize_conv
              )
          }
          
          t <- angle(x = x , y = y)
          angles <- append(angles, t["Angle_in_Radian"])
        }
        f_angles <-
          data.frame(Concept = names(Model$Concepts),
                     Similarity = cos(angles))
        f_angles <- f_angles[order(f_angles$Similarity, decreasing = T), ]
      } else{
        x <- convol(x = sub_EV, y = pred_EV, norm = Normalize_conv)
        for (i in 1:length(Model$Cardinals)) {
          t <- angle(x = x , y = Model$Cardinals[[i]][["Mem_Vector"]])
          angles <- append(angles, t["Angle_in_Radian"])
        }
        f_angles <-
          data.frame(Cardinals = names(Model$Cardinals),
                     Similarity = cos(angles))
        f_angles <- f_angles[order(f_angles$Similarity, decreasing = T), ]
      }
    }
    return(f_angles)
  }

closest_vectors<-function(composed=F,Sub="?" ,Pred="?",Relation_set="?",Model_Data){
  for(i in length(Model_Data):1){
    t<-closest_vector_model(composed=composed,Sub=Sub,Pred=Pred,
                            Relation_set=Relation_set,Model = Model_Data[[i]])
    names(t)<-c(paste("Model-",i,names(t)))
    if(i==length(Model_Data)){Sim_data<-t}else {Sim_data<-cbind(t,Sim_data)}
  }
  return(Sim_data)
}


