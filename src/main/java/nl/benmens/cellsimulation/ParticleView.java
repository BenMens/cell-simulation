package nl.benmens.cellsimulation;

import nl.benmens.processing.SharedPApplet;
import processing.core.PApplet;
import processing.core.PImage;
import processing.core.PVector;

public class ParticleView extends ViewBase {
  final float PARTICLE_SIZE = 15;

  ParticleBaseModel particleModel;

  PImage images[] = new PImage[7];

  ParticleView(ViewBase parentView, ParticleBaseModel particleModel) {
    super(parentView);

    this.particleModel = particleModel;

    for (int i = 0; i < 7; i++) {
      images[i] = ImageCache.getImage(
          "images/" + particleModel.getImageName() + "_" + String.format("%d", (long) Math.pow(2, i + 3)) + ".png");
    }
  }

  public void beforeDrawChildren() {
    PVector composedScale = this.composedScale();
    float imageScale = particleModel.getImageScale();

    float imageDimension = PApplet.max(composedScale.x * PARTICLE_SIZE * imageScale,
        composedScale.y * PARTICLE_SIZE * imageScale);
    PImage img = images[images.length - 1];

    for (int i = 0; i < images.length; i++) {
      if (imageDimension <= PApplet.pow(2, i + 3)) {
        img = images[i];
        break;
      }
    }

    SharedPApplet.image(img, particleModel.getPosition().x * 100 - PARTICLE_SIZE * 0.5f * imageScale,
        particleModel.getPosition().y * 100 - PARTICLE_SIZE * 0.5f * imageScale, PARTICLE_SIZE * imageScale,
        PARTICLE_SIZE * imageScale);
  }
}