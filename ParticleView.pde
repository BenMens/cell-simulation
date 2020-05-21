class ParticleView extends ViewBase {
    final float PARTICLE_SIZE = 15;

    ParticleBaseModel particleModel;

    PImage images[] = new PImage[7]; 


    ParticleView(ParticleBaseModel particleModel) {
        this.particleModel = particleModel;

        String imageName = "";

        if (particleModel instanceof ParticleFoodModel) {
            imageName = "food";
        } else if (particleModel instanceof ParticleWasteModel) {
            imageName = "waste";
        }

        for (int i = 0; i < 7; i++) {
            images[i] = ImageCache.getImage(applet, "images/" + imageName + "_" + String.format("%d", (long)Math.pow(2, i+3)) + ".png");        
        }
    }


    void beforeDrawChildren() {
        float imageDimension = composedScale() * PARTICLE_SIZE;
        PImage img = images[images.length - 1];

        for (int i = 0; i < images.length; i++) {
            if (imageDimension <= pow(2, i+3)) {
                img = images[i];
                break;
            } 
        }

        image(img, particleModel.getPosition().x * 100 - PARTICLE_SIZE * 0.5, particleModel.getPosition().y * 100 - PARTICLE_SIZE * 0.5, PARTICLE_SIZE, PARTICLE_SIZE);
    }
}
