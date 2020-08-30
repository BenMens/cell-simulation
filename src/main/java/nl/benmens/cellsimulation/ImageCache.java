package nl.benmens.cellsimulation;

import processing.core.PImage;
import java.util.HashMap;

import nl.benmens.processing.SharedPApplet;

public class ImageCache {

  private static ImageCache imageCache;
  private HashMap<String, PImage> cache = new HashMap<String, PImage>();

  private ImageCache() {
  }

  public static ImageCache getImageCache() {
    if (imageCache == null) {
      imageCache = new ImageCache();
    }
    return imageCache;
  }

  public PImage getImage(String name) {
    PImage resultImage = cache.get(name);

    if (resultImage == null) {
      resultImage = SharedPApplet.loadImage(name);
      cache.put(name, resultImage);
    }

    return resultImage;
  }
}
