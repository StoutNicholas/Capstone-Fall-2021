library(tidyverse)
library(cluster)
library(readr)
library(factoextra)

df <- read_csv("az_sources_merged.csv")

df_apache_arrest <- df %>% filter(Source=="total arrests")

kmeans_op<- kmeans(df_apache_arrest[,3], center=3)
df_apache_arrest$cluster <- kmeans_op$cluster

l <- vector("list",length=20)
for(i in 3:17){
  
  kmeans_op <- kmeans(df[,i],center=3) 
  
  name <- paste0(names(df[,i]),"cluster")
  l[[i]] <- kmeans_op$cluster
  # names(l[i]) <- name
  l[[i]] <- na.omit(l[[i]])
}


# Kmeans
df_new <- df
df_new[,3:17] <- scale(df_new[,3:17])


unique(df$Source)
# total arrests

df_new <- df %>% filter(Source=="total arrests")
df_new <- column_to_rownames(df_new, "Time")
kmeans_op <- kmeans(df_new[,2:16], centers = 3, nstart = 20)
df_new$cluster <- factor(kmeans_op$cluster)

fviz_cluster(kmeans_op,df_new[,2:16])+
  labs(title="Cluster plot for total arrests")

# Data partitioned into several cluster for a specific source using unspervised learning (kmeans) is represented in the plot. Each dot represents individual row item (i.e at year level)

# The plot represents two principal components (Dim1 & Dim2) for the dataset represtnting different cluster at a year level.

#The x-y corrdinates (Dim1 & Dim2) are in terms of princiapal components which are linear combinations of the original data.


df_new <- df %>% filter(Source=="crime rate")
df_new <- column_to_rownames(df_new, "Time")
kmeans_op <- kmeans(df_new[,2:16], centers = 3, nstart = 20)
df_new$cluster <- factor(kmeans_op$cluster)

fviz_cluster(kmeans_op,df_new[,2:16])+
  labs(title="Cluster plot for crime rate")

# Data partitioned into several cluster for a specific source using unspervised learning (kmeans) is represented in the plot. Each dot represents individual row item (i.e at year level)

# The plot represents two principal components (Dim1 & Dim2) for the dataset represtnting different cluster at a year level.

#The x-y corrdinates (Dim1 & Dim2) are in terms of princiapal components which are linear combinations of the original data.


#3 Source
df_new <- df %>% filter(Source=="population estimates")
df_new <- column_to_rownames(df_new, "Time")
kmeans_op <- kmeans(df_new[,2:16], centers = 3, nstart = 20)
df_new$cluster <- factor(kmeans_op$cluster)

fviz_cluster(kmeans_op,df_new[,2:16])+
  labs(title="Cluster plot for population estimates")

# Data partitioned into several cluster for a specific source using unspervised learning (kmeans) is represented in the plot. Each dot represents individual row item (i.e at year level)

# The plot represents two principal components (Dim1 & Dim2) for the dataset represtnting different cluster at a year level.

#The x-y corrdinates (Dim1 & Dim2) are in terms of princiapal components which are linear combinations of the original data.

df_new <- df %>% filter(Source=="poverty percentage")
df_new <- column_to_rownames(df_new, "Time")
kmeans_op <- kmeans(df_new[,2:16], centers = 3, nstart = 20)
df_new$cluster <- factor(kmeans_op$cluster)

fviz_cluster(kmeans_op,df_new[,2:16])+
  labs(title="Cluster plot for poverty percentage")

# Data partitioned into several cluster for a specific source using unspervised learning (kmeans) is represented in the plot. Each dot represents individual row item (i.e at year level)

# The plot represents two principal components (Dim1 & Dim2) for the dataset represtnting different cluster at a year level.

#The x-y corrdinates (Dim1 & Dim2) are in terms of princiapal components which are linear combinations of the original data.


# 5th Source
df_new <- df %>% filter(Source=="state tax")
df_new <- column_to_rownames(df_new, "Time")
kmeans_op <- kmeans(df_new[,2:16], centers = 3, nstart = 20)
df_new$cluster <- factor(kmeans_op$cluster)

fviz_cluster(kmeans_op,df_new[,2:16])+
  labs(title="Cluster plot for state tax")

# Data partitioned into several cluster for a specific source using unspervised learning (kmeans) is represented in the plot. Each dot represents individual row item (i.e at year level)

# The plot represents two principal components (Dim1 & Dim2) for the dataset represtnting different cluster at a year level.

#The x-y corrdinates (Dim1 & Dim2) are in terms of princiapal components which are linear combinations of the original data.

