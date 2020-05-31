class ParticleFactory {
    ParticleBaseModel createParticle(String type, BodyModel body) {
        switch (type) {
            case "food":
                return new ParticleFoodModel(body);
            case "waste":
                return new ParticleWasteModel(body);
            case "oxygene":
                return new ParticleOxygeneModel(body);
            case "co2":
                return new ParticleCO2Model(body);
        }

        return null;
    }
}
