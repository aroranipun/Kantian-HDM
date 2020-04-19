library(stringr)
library(readxl)
library(circular)
library(acf)
library(pracma)
library(randomizr)

#Source required funtions and data-----------------------------------------------
Categories_data<-read.csv(file = "data/Categories.csv",colClasses = "character")
source(file = "src/utils.R")
source(file = "src/hologrpahic_memory.R")

#Primitives-----------------------------------------------
Cardinals<-list(Quantity=c("Universal", "Particular", "Singular"),
                Quality=c("Affirmative","Negative","Infinite"),
                Relation=c("Categorical","Hypothetical","Disjunctive"),
                Modality=c("Problematic","Assertoric","Apodeictic"))
dimensions = 1024
placeholder<-vect()

#Model_Details-----------------------------
model_params <-
  c("Repeatable_Storage",
    "Priority_only",
    "Normalize_conv",
    "Normalize_store")

#M_parameters<-c("Priority_only")
#M_parameters<-c("Repeatable_Storage")
#M_parameters<-c("Memory_Cardinal")
#M_parameters<-c("Normalize")

#1: Convolve Relations: Store one relation with all types or seperate
#2: Cardinal Memory: Have memory for cardinal Vectors
#3: Directionality: Just change predicate mem or both
#4: Repeatable Stroage: Store multiple instances of same proposition again?
#5: Normalize: Normalize or not
#6: Primary Relations: Have  set of primary relations or not


List_models <- NULL

for (i in model_params) {
  t <- list(c("yes", "no"))
  names(t) = i
  List_models <<- append(List_models, t)
}
All_models <- expand.grid(List_models)

All_Relations <- expand.grid(list(Quantity, Quality, Relation, Modality))
