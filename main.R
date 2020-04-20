source(file = "src/setup.R")

#Model_Details-----------------------------
#Model Parameters

#1: Convolve Relations: Store one relation with all types or seperate
#2: Cardinal Memory: Have memory for cardinal Vectors
#3: Directionality: Change only predicate memory or both subject and predicate 
#4: Repeatable Stroage: Store multiple instances of same proposition again?
#5: Normalize: Normalize or not
#6: Primary Relations: Have  set of primary relations or not
#Model_Details-----------------------------
model_params <-
  c("Repeatable_Storage",
    "Priority_only",
    "Normalize_conv",
    "Normalize_store")

#model_params<-c("Priority_only")
#model_params<-c("Repeatable_Storage")
#model_params<-c("Memory_Cardinal")
model_params<-c("Normalize")
