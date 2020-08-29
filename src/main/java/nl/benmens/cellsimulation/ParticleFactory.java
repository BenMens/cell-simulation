package nl.benmens.cellsimulation;

import nl.benmens.cellsimulation.body.BodyModel;

public class ParticleFactory {

  static private ParticleFactory particleFactory;

  private ParticleFactory() {

  }

  public static ParticleFactory sharedFactory() {
    if (particleFactory == null) {
      particleFactory = new ParticleFactory();
    }

    return particleFactory;
  }

  public ParticleBaseModel createParticle(String type, BodyModel body) {
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
