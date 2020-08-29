package nl.benmens.cellsimulation;

import java.util.ArrayList;

import nl.benmens.processing.SharedPApplet;
import processing.core.PVector;

import java.awt.geom.Rectangle2D;


public class ViewBase {
  private ViewBase parentView = null;
  protected ArrayList<ViewBase> childViews = new ArrayList<ViewBase>();

  public Rectangle2D.Float frameRect; // View dimension in Parent coordinates
  public Rectangle2D.Float boundsRect; // View dimension

  boolean shouldClip = false;
  boolean isVisible = true;

  boolean hasBackground = false;
  int backgroundColor = SharedPApplet.color(255);

  private ArrayList<Object> clients = new ArrayList<Object>();

  public ViewBase(ViewBase parent) {
    if (parent == null) {
      this.frameRect = new Rectangle2D.Float(0, 0, SharedPApplet.getSharedApplet().width, SharedPApplet.getSharedApplet().height);
      this.boundsRect = new Rectangle2D.Float(0, 0, SharedPApplet.getSharedApplet().width, SharedPApplet.getSharedApplet().height);
    } else {
      this.frameRect = new Rectangle2D.Float(0, 0, parent.boundsRect.width, parent.boundsRect.height);
      this.boundsRect = new Rectangle2D.Float(0, 0, parent.boundsRect.width, parent.boundsRect.height);
      setParentView(parent);
    }
  }

  public final ViewBase getParentView() {
    return parentView;
  }

  public final void setParentView(ViewBase newParentView) {
    if (parentView != newParentView) {

      if (parentView != null) {
        parentView.childViews.remove(this);
      }

      parentView = newParentView;

      if (parentView != null) {

        if (!parentView.childViews.contains(this)) {
          parentView.childViews.add(this);

          parentView.onChildViewAdded(this);
        }
      }
    }
  }

  public final ArrayList<ViewBase> getChildViews() {
    return childViews;
  }

  public void makeChildsVisible() {
    for (ViewBase child : childViews) {
      child.isVisible = true;
    }
  }

  public void makeChildsInvisible() {
    for (ViewBase child : childViews) {
      child.isVisible = false;
    }
  }

  public final void draw() {
    Rectangle2D.Float clipBoundary = getClipBoundary();

    if (clipBoundary == null || (clipBoundary.width > 0 && clipBoundary.height > 0)) {
      SharedPApplet.push();

      if (clipBoundary != null) {
        SharedPApplet.clip(clipBoundary.x, clipBoundary.y, clipBoundary.width, clipBoundary.height);
      } else {
        SharedPApplet.noClip();
      }

      SharedPApplet.translate(frameRect.x, frameRect.y);
      PVector scale = getScale();
      SharedPApplet.scale(scale.x, scale.y);
      SharedPApplet.translate(-boundsRect.x, -boundsRect.y);

      if (isVisible) {
        if (hasBackground) {
          SharedPApplet.background(backgroundColor);

        }
        beforeDrawChildren();

        for (ViewBase childView : childViews) {
          childView.draw();
        }

        afterDrawChildren();
      }

      SharedPApplet.pop();
    }
  }

  public void beforeDrawChildren() {
  }

  public void afterDrawChildren() {
  }

  public PVector composedScale() {
    PVector result = getScale();

    if (this.parentView != null) {
      PVector parentScale = this.parentView.composedScale();

      result.x *= parentScale.x;
      result.y *= parentScale.y;
    }

    return result;
  }

  public PVector screenSizeToViewSize(PVector size) {
    PVector result = size.copy();

    if (parentView != null) {
      result = parentView.screenSizeToViewSize(result);
    }

    PVector scale = getScale();

    result.x /= scale.x;
    result.y /= scale.y;

    return result;
  }

  public PVector getScale() {
    return new PVector(frameRect.width / boundsRect.width, frameRect.height / boundsRect.height);
  }

  public void setScale(float scale) {
    boundsRect.width = frameRect.width / scale;
    boundsRect.height = frameRect.height / scale;
  }

  public void setScale(PVector scale) {
    boundsRect.width = frameRect.width / scale.x;
    boundsRect.height = frameRect.height / scale.y;
  }

  public PVector viewSizeToScreenSize(PVector size) {
    PVector result = size.copy();

    PVector scale = getScale();
    result.x *= scale.x;
    result.y *= scale.y;

    if (parentView != null) {
      result = parentView.viewSizeToScreenSize(result);
    }

    return result;
  }

  public PVector screenPosToViewPos(PVector pos) {
    PVector result = pos.copy();

    if (parentView != null) {
      result = parentView.screenPosToViewPos(result);
    }

    result.sub(frameRect.x, frameRect.y);

    PVector scale = getScale();
    result.x /= scale.x;
    result.y /= scale.y;

    result.add(boundsRect.x, boundsRect.y);

    return result;
  }

  public PVector viewPosToScreenPos(PVector pos) {
    PVector result = pos.copy();

    result.sub(boundsRect.x, boundsRect.y);

    PVector scale = getScale();
    result.x *= scale.x;
    result.y *= scale.y;

    result.add(frameRect.x, frameRect.y);

    if (parentView != null) {
      result = parentView.viewPosToScreenPos(result);
    }

    return result;
  }

  public Rectangle2D.Float getClipBoundary() {
    Rectangle2D.Float viewClip = null;
    Rectangle2D.Float parentViewClip = null;

    if (shouldClip) {
      PVector upperLeft = viewPosToScreenPos(new PVector(boundsRect.x, boundsRect.y));
      PVector lowerRight = viewPosToScreenPos(new PVector(boundsRect.width, boundsRect.height));

      viewClip = new Rectangle2D.Float(upperLeft.x, upperLeft.y, lowerRight.x - upperLeft.x,
          lowerRight.y - upperLeft.y);
    }

    if (parentView != null) {
      parentViewClip = parentView.getClipBoundary();
    }

    if (viewClip != null && parentViewClip != null) {
      Rectangle2D intersection = parentViewClip.createIntersection(viewClip);

      return new Rectangle2D.Float((float) intersection.getX(), (float) intersection.getY(),
          (float) intersection.getWidth(), (float) intersection.getHeight());
    } else if (viewClip != null) {
      return viewClip;
    } else if (parentViewClip != null) {
      return parentViewClip;
    }

    return null;
  }

  // ########################################################################
  // Subscriber handling
  // ########################################################################
  protected <T> ArrayList<T> getClientsImplementing(Class<T> interfaceClass) {
    ArrayList<T> result = new ArrayList<T>();

    for (Object client : clients) {
      if (interfaceClass.isInstance(client)) {
        result.add((T) client);
      }
    }

    return result;
  }

  public void registerClient(Object client) {
    if (!clients.contains(client)) {
      clients.add(client);
    }
  }

  public void unregisterClient(Object client) {
    clients.remove(client);
  }

  // ########################################################################
  // Mouse move handling
  // ########################################################################

  public final boolean processMouseMoveEvent(float mouseX, float mouseY, float pmouseX, float pmouseY) {
    Rectangle2D.Float boundary = getClipBoundary();
    boolean handled = false;

    for (ViewBase childView : childViews) {
      handled = childView.processMouseMoveEvent(mouseX, mouseY, pmouseX, pmouseY);
      if (handled) {
        break;
      }
    }

    if (!handled && (boundary == null || boundary.contains(mouseX, mouseY))) {
      PVector mousePos = screenPosToViewPos(new PVector(mouseX, mouseY));
      PVector pmousePos = screenPosToViewPos(new PVector(pmouseX, pmouseY));
      handled = onMouseMove(mousePos.x, mousePos.y, pmousePos.x, pmousePos.y);
    }

    return handled;
  }

  public boolean onMouseMove(float mouseX, float mouseY, float pmouseX, float pmouseY) {
    return false;
  }

  // ########################################################################
  // Mouse drag handling
  // ########################################################################

  public final boolean processMouseDraggedEvent(float mouseX, float mouseY, float pmouseX, float pmouseY) {
    Rectangle2D.Float boundary = getClipBoundary();
    boolean handled = false;

    for (ViewBase childView : childViews) {
      handled = childView.processMouseDraggedEvent(mouseX, mouseY, pmouseX, pmouseY);
      if (handled) {
        break;
      }
    }

    if (!handled && (boundary == null || boundary.contains(mouseX, mouseY))) {
      PVector mousePos = screenPosToViewPos(new PVector(mouseX, mouseY));
      PVector pmousePos = screenPosToViewPos(new PVector(pmouseX, pmouseY));
      handled = onMouseDragged(mousePos.x, mousePos.y, pmousePos.x, pmousePos.y);
    }

    return handled;
  }

  public boolean onMouseDragged(float mouseX, float mouseY, float pmouseX, float pmouseY) {
    return false;
  }

  // ########################################################################
  // Mouse scroll handling
  // ########################################################################

  public final boolean processScrollEvent(float mouseX, float mouseY, float mouseScroll) {
    Rectangle2D.Float boundary = getClipBoundary();
    boolean handled = false;

    for (ViewBase childView : childViews) {
      handled = childView.processScrollEvent(mouseX, mouseY, mouseScroll);
      if (handled) {
        break;
      }
    }

    if (!handled && (boundary == null || boundary.contains(mouseX, mouseY))) {
      PVector mousePos = screenPosToViewPos(new PVector(mouseX, mouseY));
      handled = onScroll(mousePos.x, mousePos.y, mouseScroll);
    }

    return handled;
  }

  public boolean onScroll(float mouseX, float mouseY, float mouseScroll) {
    return false;
  }

  // ########################################################################
  // Mouse press handling
  // ########################################################################

  public final boolean processMouseButtonEvent(float mouseX, float mouseY, boolean mousePressed, int mouseButton) {
    Rectangle2D.Float boundary = getClipBoundary();
    boolean handled = false;

    for (ViewBase childView : childViews) {
      handled = childView.processMouseButtonEvent(mouseX, mouseY, mousePressed, mouseButton);
      if (handled) {
        break;
      }
    }

    if (!handled && (boundary == null || boundary.contains(mouseX, mouseY))) {
      PVector mousePos = screenPosToViewPos(new PVector(mouseX, mouseY));
      handled = onMouseButtonEvent(mousePos.x, mousePos.y, mousePressed, mouseButton);
    }

    return handled;
  }

  public boolean onMouseButtonEvent(float mouseX, float mouseY, boolean mousePressed, int mouseButton) {
    return false;
  }

  // ########################################################################
  // Key press handling
  // ########################################################################

  public final boolean processKeyEvent(boolean pressed, int key) {
    Rectangle2D.Float boundary = getClipBoundary();
    boolean handled = false;

    for (ViewBase childView : childViews) {
      handled = childView.processKeyEvent(pressed, key);
      if (handled) {
        break;
      }
    }

    if (!handled && (boundary == null || boundary.contains(SharedPApplet.getSharedApplet().mouseX, SharedPApplet.getSharedApplet().mouseY))) {
      handled = onKeyEvent(pressed, key);
    }

    return handled;
  }

  public boolean onKeyEvent(boolean pressed, int key) {
    return false;
  }

  // ########################################################################
  // FrameRect
  // ########################################################################

  public void setFrameRect(double x, double y, double width, double height) {
    Rectangle2D.Float oldRect = (Rectangle2D.Float) frameRect.clone();

    frameRect.setRect(x, y, width, height);

    onFrameRectChange(oldRect);
  }

  public Rectangle2D.Float getFrameRect() {
    return (Rectangle2D.Float) frameRect.clone();
  }

  public void onFrameRectChange(Rectangle2D.Float oldRect) {
  }

  // ########################################################################
  // BoundsRect
  // ########################################################################

  public void setBoundsRect(double x, double y, double width, double height) {
    boundsRect.setRect(x, y, width, height);
  }

  public Rectangle2D.Float getBoundsRect() {
    return (Rectangle2D.Float) boundsRect.clone();
  }

  // ########################################################################
  // View child events
  // ########################################################################

  public void onChildViewAdded(ViewBase clientView) {
  }

  // ########################################################################
  // Destruction
  // ########################################################################

  public final void destroy() {
    this.setParentView(null);

    for (ViewBase childView : (ArrayList<ViewBase>) childViews.clone()) {
      childView.destroy();
    }

    onDestroy();
  }

  public void onDestroy() {
  }

}