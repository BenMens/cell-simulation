class ParticleView extends ViewBase {
    ArrayList<ParticleViewClient> clients = new ArrayList<ParticleViewClient>();
    ParticleBaseModel particleModel;


    ParticleView(ParticleBaseModel particleModel) {
        this.particleModel = particleModel;

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
        if (particleModel instanceof ParticleFoodModel) {
            ParticleFoodModel foodParticle = (ParticleFoodModel)particleModel;
            
            PImage img = ImageCache.getImage(applet, "images/food.png");
            image(img, particleModel.getPosition().x * 100 - img.width * 0.5, particleModel.getPosition().y * 100 - img.height * 0.5);
        } else if (particleModel instanceof ParticleWasteModel) {
            ParticleWasteModel wasteParticle = (ParticleWasteModel)particleModel;
            
            PImage img = ImageCache.getImage(applet, "images/waste.png");
            image(img, wasteParticle.getPosition().x * 100 - img.width * 0.5, wasteParticle.getPosition().y * 100 - img.height * 0.5);
        }
    }
}
