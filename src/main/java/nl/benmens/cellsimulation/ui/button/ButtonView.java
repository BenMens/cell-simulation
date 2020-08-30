package nl.benmens.cellsimulation.ui.button;

import processing.core.PImage;
import java.awt.geom.Rectangle2D;

import nl.benmens.processing.SharedPApplet;
import nl.benmens.processing.mvc.View;
import nl.benmens.processing.observer.Subject;
import nl.benmens.processing.observer.Subscription;
import nl.benmens.processing.observer.SubscriptionManager;

public class ButtonView extends View {

  private PImage buttonImage;

  private Subject<ButtonViewEventHandler> buttonEvents = new Subject<ButtonViewEventHandler>(this);

  public ButtonView(View parentView) {
    super(parentView);
  }

  public PImage getButtonImage() {
    return buttonImage;
  }

  public void setButtonImage(PImage buttonImage) {
    this.buttonImage = buttonImage;
  }

  public void beforeDrawChildren() {
    if (getButtonImage() != null) {
      Rectangle2D.Float boundsRect = getBoundsRect();

      SharedPApplet.image(getButtonImage(), boundsRect.x, boundsRect.y, boundsRect.width, boundsRect.height);
    }
  }

  @Override
  public boolean mousePressed(float mouseX, float mouseY, float pmouseX, float pmouseY) {
    for (ButtonViewEventHandler s: buttonEvents.getSubscribers()) {
      s.onClick(this);
    } 
    return true;
  }

  public Subscription<?> subscribe(ButtonViewEventHandler observer, SubscriptionManager subscriptionManager) {
    return buttonEvents.subscribe(observer, subscriptionManager);
  }

  

}