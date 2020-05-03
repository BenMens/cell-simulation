class ParticleView extends ViewBase {
    
    ParticleBaseModel particleModel;

    ParticleView(ParticleBaseModel particleModel) {
        this.particleModel = particleModel;

    }

    void beforeDrawChildren() {
        if (particleModel instanceof FoodParticleModel) {
            FoodParticleModel foodParticle = (FoodParticleModel)particleModel;
            
            PImage img = ImageCache.getImage(applet, "images/food.png");
            image(img, particleModel.getPosition().x - 12, particleModel.getPosition().y - 12);
        } else if (particleModel instanceof WasteParticleModel) {
            WasteParticleModel wasteParticle = (WasteParticleModel)particleModel;
            
            PImage img = ImageCache.getImage(applet, "images/waste.png");
            image(img, wasteParticle.getPosition().x - 12, wasteParticle.getPosition().y - 12);
        }
    }
}
