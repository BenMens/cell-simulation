import processing.core.PImage;
import processing.core.PApplet;
import processing.core.PShape;
import java.util.HashMap;

public class ImageCache {

  static HashMap<String, PImage> imageCache = new HashMap<String, PImage>();

  static PImage getImage(PApplet applet, String name) {
    PImage resultImage = imageCache.get(name);

    if (resultImage == null) {
      resultImage = applet.loadImage(name);
      imageCache.put(name, resultImage);
    }

    return resultImage;
  }
}
