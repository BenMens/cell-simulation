package nl.benmens.cellsimulation.ui;

import processing.core.PImage;
import java.awt.geom.Rectangle2D;

import nl.benmens.processing.SharedPApplet;
import nl.benmens.processing.mvc.View;
import nl.benmens.processing.observer.Subject;
import nl.benmens.processing.observer.Subscription;
import nl.benmens.processing.observer.SubscriptionManager;

public class ButtonView extends View {

  public PImage buttonImage;

  Subject<ButtonViewClient> buttonEvents = new Subject<ButtonViewClient>(this);

  public ButtonView(View parentView) {
    super(parentView);
  }

  public void beforeDrawChildren() {
    if (buttonImage != null) {
      Rectangle2D.Float boundsRect = getBoundsRect();

      SharedPApplet.image(buttonImage, boundsRect.x, boundsRect.y, boundsRect.width, boundsRect.height);
    }
  }

  @Override
  public void mousePressed(float mouseX, float mouseY, float pmouseX, float pmouseY) {
    for (ButtonViewClient s: buttonEvents.getSubscribers()) {
      s.onClick(this);
    } 
  }

  public Subscription<?> subscribe(ButtonViewClient observer, SubscriptionManager subscriptionManager) {
    return buttonEvents.subscribe(observer, subscriptionManager);
  }

  

}