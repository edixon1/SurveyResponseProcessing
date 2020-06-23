library(magick)

#read in images to list
catImages <- list.files(path="Data/Raw/Cats", full.names=T) %>%
  lapply(image_read)

#create list containing info for each image
catInfo <- lapply(catImages, image_info)
catInfo <- do.call("rbind", catInfo)

#assign max height and max width
maxWidth <- max(catInfo$width)
maxHeight <- max(catInfo$height)

#Modify dimensions of picture so the amount of border to add to each side will always be even
for(i in 1:length(catImages)){
  #add border to top and bottom of each image so each image has equal dimensions
  if(maxWidth %% 2 == 0){
    if(catInfo[i,]$width %% 2 != 0){
      catImages[[i]] = image_resize(catImages[[i]], paste(catInfo[i,]$width + 1,"!", sep=""))
    }
  }else{
    if(catInfo[i,]$width %% 2 == 0){
      catImages[[i]] = image_resize(catImages[[i]], paste(catInfo[i,]$width + 1,"!", sep=""))
    }
  }
  
  if(maxHeight %% 2 == 0 ){
    if(catInfo[i,]$height %% 2 != 0){
      catImages[[i]] = image_resize(catImages[[i]], paste("x",catInfo[i,]$height + 1,"!", sep=""))
    }
  }else{
    if(catInfo[i,]$height %% 2 == 0){
      catImages[[i]] = image_resize(catImages[[i]], paste("x",catInfo[i,]$height + 1,"!", sep=""))
    }
  }
}

#update image information
catInfo <- lapply(catImages, image_info)
catInfo <- do.call("rbind", catInfo)

#todo round one way or another

#initialize results container
borderedImages <- list()
for(i in 1:length(catImages)){
  #add border to top and bottom of each image so each image has equal dimensions


  borderWidth <- (maxWidth - catInfo[i,]$width)/2
  borderHeight <- (maxHeight - catInfo[i,]$height)/2
  print(paste("Width: ",catInfo[i,]$width,"  Height: ",catInfo[i,]$height))
  print(paste("Border width: ",borderWidth,"  Border height: ",borderHeight))
  print("----------------------------------------")
  
  currentImage <- image_border(catImages[[i]],"red",paste(borderWidth,"x",borderHeight, sep="")) %>%
  #add label to bottom of image displaying image ID
  image_border("black", geometry="0x22") %>%
  image_crop(geometry="0x0+0+22") %>%
  image_annotate(text=paste("image_",i,sep=""),size=18,color="white",gravity="southwest")
  #save modified images and write to results folder
  borderedImages[[i]] <- currentImage
  image_write(currentImage, path=paste("Data/Results/CatBorders/cat",i,".jpeg",sep=""))
}







