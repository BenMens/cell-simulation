package nl.benmens.cellsimulation.particle;

import nl.benmens.cellsimulation.codon.ControllerBase;
import nl.benmens.processing.mvc.View;

public class ParticleController extends ControllerBase implements ParticleModelClient {
  ParticleBaseModel particleModel;
  ParticleView particleView;

  public ParticleController(ControllerBase parentController, View parentView, ParticleBaseModel particleModel) {
    super(parentController);

    this.particleModel = particleModel;
    this.particleView = new ParticleView(parentView, particleModel);

    this.particleModel.registerClient(this);
  }

  public void onDestroy() {
    particleView.destroy();
    particleModel.unregisterClient(this);
  }

  public void onDestroy(ParticleBaseModel particleModel) {
  }

}