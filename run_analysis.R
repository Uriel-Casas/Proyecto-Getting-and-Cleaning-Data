library(plyr)

#Obteniendo los datos
TestY  <- read.table("./UCI HAR Dataset/test/Y_test.txt",header = FALSE)
TrainY <- read.table("./UCI HAR Dataset/train/y_train.txt",header = FALSE)
SubjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt",header = FALSE)
SubjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt",header = FALSE)
TestX  <- read.table("./UCI HAR Dataset/test/X_test.txt",header = FALSE)
TrainX <- read.table("./UCI HAR Dataset/train/X_train.txt",header = FALSE)
CaracNom <-  read.table("./UCI HAR Dataset/features.txt",header = FALSE)
EtiquetasAct <- read.table("./UCI HAR Dataset/activity_labels.txt",header = FALSE) 

#Concatenar las tablas de datos 
dataS <- rbind(SubjectTrain, SubjectTest)
dataF <- rbind(TrainX, TestX)
dataA <- rbind(TrainY, TestY)

#Nombres de las columnas
names(dataS)<-c("tema")
names(dataA)<- c("actividad")
names(dataF)<- CaracNom$V2

#Fusiona las tablas creadas
tablaC <- cbind(dataS,dataA)
tabla <-  cbind(dataF, tablaC)

#Extrae solo las mediciones de la media y la desviación estándar para cada medición.
SNomCar <- CaracNom$V2[grep("mean|std", CaracNom$V2)]
NomSelec <- c(as.character(SNomCar), "tema", "actividad")
tabla <- subset(tabla, select= NomSelec )

#Descripciones
names(tabla)<-gsub("^t", "tiempo", names(tabla))
names(tabla)<-gsub("^f", "frecuencia", names(tabla))
names(tabla)<-gsub("Acc", "Accelometro", names(tabla))
names(tabla)<-gsub("Giro", "Giroscopio", names(tabla))
names(tabla)<-gsub("Mag", "Magnitud", names(tabla))
names(tabla)<-gsub("Cuerp", "Cuerpo", names(tabla))

#A partir del conjunto de datos en el paso 4, crea un segundo conjunto de datos ordenado independiente con el promedio de cada variable para cada actividad y cada sujeto.
tabla2 <- aggregate(. ~tiempoema + actividad, tabla, mean)
tabla2 <- tabla2[order(tabla2$tiempoema,tabla2$actividad),]
write.table(tabla2, file = "./UCI HAR Dataset/tidy_data.txt",row.name=FALSE)
