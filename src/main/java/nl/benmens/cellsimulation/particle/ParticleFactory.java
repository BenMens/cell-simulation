package nl.benmens.cellsimulation.particle;

import nl.benmens.cellsimulation.body.BodyModel;
import nl.benmens.cellsimulation.particle.co2.CO2ParticleModel;
import nl.benmens.cellsimulation.particle.food.FoodParticleModel;
import nl.benmens.cellsimulation.particle.oxygene.OxygeneParticleModel;
import nl.benmens.cellsimulation.particle.waste.WasteParticleModel;

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
        return new FoodParticleModel(body);
      case "waste":
        return new WasteParticleModel(body);
      case "oxygene":
        return new OxygeneParticleModel(body);
      case "co2":
        return new CO2ParticleModel(body);
    }

    return null;
  }
}
