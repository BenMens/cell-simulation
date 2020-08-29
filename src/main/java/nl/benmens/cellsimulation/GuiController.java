package nl.benmens.cellsimulation;

import nl.benmens.cellsimulation.body.BodyController;
import nl.benmens.cellsimulation.body.BodyModel;
import nl.benmens.cellsimulation.body.BodyModelClient;
import nl.benmens.cellsimulation.cell.CellEditorController;
import nl.benmens.cellsimulation.cell.CellModel;
import nl.benmens.cellsimulation.codon.ControllerBase;
import nl.benmens.cellsimulation.particle.ParticleBaseModel;
import nl.benmens.cellsimulation.ui.ButtonView;
import nl.benmens.cellsimulation.ui.ButtonViewClient;
import nl.benmens.processing.SharedPApplet;
import nl.benmens.processing.mvc.View;
import nl.benmens.processing.observer.Subject;
import nl.benmens.processing.observer.Subscription;
import nl.benmens.processing.observer.SubscriptionManager;

import java.awt.geom.Rectangle2D;

public class GuiController extends ControllerBase implements BodyModelClient, ButtonViewClient {
  View parentView;
  BodyModel bodyModel;
  BodyController bodyController;
  ZoomView bodyContainerView;
  CellEditorController cellEditorController;
  View toolbarView;
  ButtonView playButton;
  ButtonView pauzeButton;

  public SubscriptionManager subscriptionManager = new SubscriptionManager();

  GuiController(ControllerBase parentController, View parentView, BodyModel bodyModel) {
    super(parentController);

    this.parentView = parentView;
    this.bodyModel = bodyModel;

    bodyContainerView = new ZoomView(parentView);

    bodyController = new BodyController(this, bodyContainerView, bodyModel);

    toolbarView = new View(parentView);
    toolbarView.shouldClip = true;
    toolbarView.hasBackground = true;
    toolbarView.backgroundColor = SharedPApplet.color(100, 100, 255);

    playButton = new ButtonView(toolbarView);
    playButton.shouldClip = true;
    playButton.buttonImage = ImageCache.getImage("images/play-button.png");
    playButton.subscribe(this, subscriptionManager);

    pauzeButton = new ButtonView(toolbarView);
    pauzeButton.shouldClip = true;
    pauzeButton.buttonImage = ImageCache.getImage("images/pauze-button.png");
    pauzeButton.subscribe(this, subscriptionManager);

    bodyContainerView.setZoomView(bodyController.bodyView);

    bodyModel.registerClient(this);

    this.updateLayout();
  }

  public void beforeLayoutChildren() {
    Rectangle2D.Float parentRect = this.parentView.getFrameRect();

    toolbarView.setFrameRect(0, 0, parentRect.width, 80);
    toolbarView.setBoundsRect(0, 0, parentRect.width, 80);

    playButton.setFrameRect(parentRect.width - 170, 10, 60, 60);
    pauzeButton.setFrameRect(parentRect.width - 100, 10, 60, 60);

    bodyContainerView.setFrameRect(20, 100, parentRect.height - 120, parentRect.height - 40);

    if (this.cellEditorController != null) {
      this.cellEditorController.cellEditorView.setFrameRect(parentRect.height - 80, 100,
          parentRect.width - parentRect.height + 60, parentRect.height - 120);
    }
  }

  public void onSelectCell(CellModel selectedCell) {
    if (this.cellEditorController != null) {
      this.cellEditorController.destroy();
      this.cellEditorController = null;
    }

    if (selectedCell != null) {
      this.cellEditorController = new CellEditorController(this, parentView, selectedCell);
    }

    this.updateLayout();
  }

  public void onAddCell(CellModel cellModel) {
  }

  public void onAddParticle(ParticleBaseModel particleModel) {
  }

  public void onClick(ButtonView button) {
    if (button == pauzeButton) {
      bodyModel.pauzed = true;
    } else if (button == playButton) {
      bodyModel.pauzed = false;
    }

  }

}