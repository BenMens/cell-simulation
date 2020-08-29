package nl.benmens.cellsimulation.particle;

import nl.benmens.cellsimulation.ViewBase;
import nl.benmens.cellsimulation.codon.ControllerBase;

public class ParticleController extends ControllerBase implements ParticleModelClient, ParticleViewClient {
  ParticleBaseModel particleModel;
  ParticleView particleView;

  public ParticleController(ControllerBase parentController, ViewBase parentView, ParticleBaseModel particleModel) {
    super(parentController);

    this.particleModel = particleModel;
    this.particleView = new ParticleView(parentView, particleModel);

    this.particleModel.registerClient(this);
    this.particleView.registerClient(this);
  }

  public void onDestroy() {
    particleView.destroy();
    particleView.unregisterClient(this);
    particleModel.unregisterClient(this);
  }

  public void onDestroy(ParticleBaseModel particleModel) {
  }

}