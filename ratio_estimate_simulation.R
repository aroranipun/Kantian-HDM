#Simulations for Ratio estimate----------------------------
dimensions = 4096
test<-NULL
sim=20
nobjs=10

for(k in 1:sim){
  
  for (i in 1:nobjs){
    initiate(repeat_store = T,
             priority_category = F,
             #norm_conv = F, 
             norm_store = F,
             dimensions = dimensions)
    
    add_concept(x = "Ball")
    add_concept(x = "Broken")
    
    N = i     # For Broken
    M = nobjs - N  # For Unbroken
    
    while (N != 0) {
      t1 <-
        relate_main(
          Sub = "Ball",
          Pred = "Broken",
          Quality = 1,
          singlerun = T
        )
      N = N - 1
    }
    while (M != 0) {
      t2 <-
        relate_main(
          Sub = "Ball",
          Pred = "Broken",
          Quality = 2,
          singlerun = T
        )
      M = M - 1
    }
    Diffs = NULL
    Ratios <- NULL
    
    N = i     #For Broken
    M = nobjs - N  # For Unbroken
    
    for (j in 1:length(Model_Data)) {
      X <- dot(x = Model_Data[[j]]$Concepts$Ball$Mem_Vector,
               y = t1$Change_SubMV[[1]])
      Y <-
        dot(x = Model_Data[[j]]$Concepts$Ball$Mem_Vector, t2$Change_SubMV[[1]])
      Ratio = abs(X / Y)
      Ratios = append(Ratios, Ratio)
    }
    t <- c(paste("Sim", k), N, M, Ratios)
    if (k == 1 &
        i == 1) {
      test <- t(data.frame(t))
    } else {
      test <- rbind(test, t(data.frame(t)))
    }
  }
}

test <- data.frame(test)
names(test)<-c("Simulation","Broken","Unbroken", paste("Model-",seq(1:length(Model_Data))))

write.csv(x = test,"Change in ratio.csv")
