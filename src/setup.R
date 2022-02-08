
library(dplyr)
library(pracma)

#Source required funtions and data-----------------------------------------------
Categories_data<-read.csv(file = "data/Categories.csv",colClasses = "character")
source(file = "src/utils.R")
source(file = "src/hologrpahic_memory.R")

#Primitives-----------------------------------------------
Cardinals<-list(Quantity=c("Universal", "Particular", "Singular"),
                Quality=c("Affirmative","Negative","Infinite"),
                Relation=c("Categorical","Hypothetical","Disjunctive"),
                Modality=c("Problematic","Assertoric","Apodeictic"))


all_relations <- expand.grid(list(Quantity = Cardinals$Quantity, 
                                  Quality = Cardinals$Quality, 
                                  Relation = Cardinals$Relation, 
                                  Modality = Cardinals$Modality))

#Setup Paramters for various model types-------------------------------

#Model Parameters
#1: Convolve Relations: Store one relation with all types or seperate
#2: Cardinal Memory: Have memory for cardinal Vectors
#3: Directionality: Change only predicate memory or both subject and predicate

#4: Repeatable Stroage: Repeatable_Storage -- Store multiple instances of same proposition again?
#5: Normalize: 
#### 5.1  Normalize_conv -- Normalize after every convolution operation
#### 5.2 Normalize_store -- Normalize before storing 
#6: Primary Relations: Priority_only -- Have  set of primary relations or not. 
model_params <-
  c("Repeatable_Storage",
    "Priority_only",
    "Normalize_conv",
    "Normalize_store")


List_models <- NULL

for (i in model_params) {
  t <- list(c(TRUE, FALSE))
  names(t) = i
  List_models <<- append(List_models, t)
}

models <- expand.grid(List_models,stringsAsFactors = F)

All_Relations <- expand.grid(list(Quantity = Cardinals$Quantity, 
                                  Quality = Cardinals$Quality, 
                                  Relation = Cardinals$Relation, 
                                  Modality = Cardinals$Modality))