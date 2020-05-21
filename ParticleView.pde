class ParticleView extends ViewBase {
    
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

        for (int i=0; i<7; i++) {
            images[i] = ImageCache.getImage(applet, "images/" + imageName + "_" + String.format("%d", (long)Math.pow(2, i+3)) + ".png");        
        }
    }

    void beforeDrawChildren() {
        float imageDimension = composedScale() * 15;
        PImage img = images[0];

        for (int i=0; i<images.length; i++) {
            img = images[i];
            if (imageDimension <= Math.pow(2, i+3)) {
                break;
            } 
        }

        image(img, particleModel.getPosition().x * 100 - 7.5, particleModel.getPosition().y * 100 - 7.5, 15, 15);
    }
}
