class ParticleView extends ViewBase {
    final float PARTICLE_SIZE = 15;

    ArrayList<ParticleViewClient> clients = new ArrayList<ParticleViewClient>();
    ParticleBaseModel particleModel;

    PImage images[] = new PImage[7]; 


    ParticleView(ViewBase parentView, ParticleBaseModel particleModel) {
        super(parentView);
        
        this.particleModel = particleModel;

        for (int i = 0; i < 7; i++) {
            images[i] = ImageCache.getImage(applet, "images/" + particleModel.getImageName() + "_" + String.format("%d", (long)Math.pow(2, i+3)) + ".png");        
        }
    }

    void registerClient(ParticleViewClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }
    }

    void unregisterClient(ParticleViewClient client) {
        clients.remove(client);
    }


    void beforeDrawChildren() {
        PVector composedScale = this.composedScale();
        float imageScale = particleModel.getImageScale();

        float imageDimension = max(
            composedScale.x * PARTICLE_SIZE * imageScale, 
            composedScale.y * PARTICLE_SIZE * imageScale);
        PImage img = images[images.length - 1];

        for (int i = 0; i < images.length; i++) {
            if (imageDimension <= pow(2, i+3)) {
                img = images[i];
                break;
            } 
        }

        image(img, 
            particleModel.getPosition().x * 100 - PARTICLE_SIZE * 0.5 * imageScale, 
            particleModel.getPosition().y * 100 - PARTICLE_SIZE * 0.5 * imageScale, 
            PARTICLE_SIZE * imageScale, 
            PARTICLE_SIZE * imageScale);
    }
}
