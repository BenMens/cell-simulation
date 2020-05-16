class ParticleView extends ViewBase {
    
    ParticleBaseModel particleModel;

    ParticleView(ParticleBaseModel particleModel) {
        this.particleModel = particleModel;

    }

    void beforeDrawChildren() {
        if (particleModel instanceof FoodParticleModel) {
            FoodParticleModel foodParticle = (FoodParticleModel)particleModel;
            
            PImage img = ImageCache.getImage(applet, "images/food.png");
            image(img, particleModel.getPosition().x * 100 - img.width * 0.5 + 10, particleModel.getPosition().y * 100 - img.height * 0.5 + 10);
        } else if (particleModel instanceof WasteParticleModel) {
            WasteParticleModel wasteParticle = (WasteParticleModel)particleModel;
            
            PImage img = ImageCache.getImage(applet, "images/waste.png");
            image(img, wasteParticle.getPosition().x * 100 - img.width * 0.5 + 10, wasteParticle.getPosition().y * 100 - img.height * 0.5 + 10);
        }
    }
}
