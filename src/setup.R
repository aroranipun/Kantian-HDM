renv::init()


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


List_models <- NULL

for (i in model_params) {
  t <- list(c("yes", "no"))
  names(t) = i
  List_models <<- append(List_models, t)
}
models <- expand.grid(List_models,stringsAsFactors = F)

All_Relations <- expand.grid(list(Quantity = Cardinals$Quantity, 
                                  Quality = Cardinals$Quality, 
                                  Relation = Cardinals$Relation, 
                                  Modality = Cardinals$Modality))
