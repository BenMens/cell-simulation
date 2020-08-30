package nl.benmens.cellsimulation.particle;

import nl.benmens.processing.mvc.Controller;
import nl.benmens.processing.mvc.View;

public class ParticleController extends Controller implements ParticleModelClient {
  private ParticleBaseModel particleModel;
  private ParticleView particleView;

  public ParticleController(Controller parentController, View parentView, ParticleBaseModel particleModel) {
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