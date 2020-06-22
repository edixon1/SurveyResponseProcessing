library(magick)

# files <- list.files(path="path/to/dir", pattern="*.txt", full.names=TRUE, recursive=FALSE)

catImages <- list.files(path="Data/Raw/Cats", full.names=T) %>%
  lapply(image_read)

catInfo <- lapply(catImages, image_info)
catInfo <- do.call("rbind", catInfo)
maxWidth <- max(catInfo$width)
maxHeight <- max(catInfo$height)


resizedImages <- list()
for(i in 1:length(catImages)){
  borderWidth <- (maxWidth - catInfo[i,]$width)/2
  borderHeight <- (maxHeight - catInfo[i,]$height)/2
  currentImage <- image_border(catImages[[i]],"red",paste(borderWidth,"x",borderHeight, sep="")) %>% 
    image_border("black", geometry="0x22") %>%
    image_crop(geometry="0x0+0+22") %>%
    image_annotate(text=paste("image_",i,sep=""),size=18,color="white",gravity="southwest")
  resizedImages[[i]] <- currentImage
  image_write(currentImage, path=paste("Data/Results/CatBorders/cat",i,".jpeg",sep=""))
}

