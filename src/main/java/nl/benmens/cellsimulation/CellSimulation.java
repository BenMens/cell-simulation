package nl.benmens.cellsimulation;

import processing.core.PVector;
import nl.benmens.processing.SharedPApplet;
import nl.benmens.processing.mvc.View;
import nl.benmens.cellsimulation.body.BodyModel;
import nl.benmens.processing.PApplet;

public class CellSimulation extends PApplet {

	PApplet applet = this;

	View rootView;
	BodyModel bodyModel;
	GuiController guiController;

	public void settings() {
		SharedPApplet.setSharedApplet(this);
		fullScreen(P2D);
	}

	public void setup() {

		rootView = new View(null);
		rootView.hasBackground = true;
		rootView.backgroundColor = color(255);
		bodyModel = new BodyModel(new PVector(10, 10));

		guiController = new GuiController(null, rootView, bodyModel);

		createFont("courrier.dfont", 24);

		frameRate(30);
	}

	public void draw() {
		bodyModel.loop();

		rootView.draw();
	}

	// public void mouseWheel(MouseEvent event) {
	// 	rootView.processScrollEvent(mouseX, mouseY, -event.getCount());
	// }

	// public void keyPressed() {
	// 	if (key < keysPressed.length) {
	// 		keysPressed[key] = true;
	// 	}

	// 	rootView.processKeyEvent(true, key);
	// }

	// public void keyReleased() {
	// 	if (key < keysPressed.length) {
	// 		keysPressed[key] = false;
	// 	}

	// 	rootView.processKeyEvent(false, key);
	// }

	// public void mousePressed() {
	// 	rootView.processMouseButtonEvent(mouseX, mouseY, true, mouseButton);
	// }

	// public void mouseReleased() {
	// 	rootView.processMouseButtonEvent(mouseX, mouseY, false, mouseButton);
	// }

	// public void mouseMoved() {
	// 	rootView.processMouseMoveEvent(mouseX, mouseY, pmouseX, pmouseY);
	// }

	// public void mouseDragged() {
	// 	rootView.processMouseDraggedEvent(mouseX, mouseY, pmouseX, pmouseY);
	// }

	static public void main(String[] passedArgs) {
		if (passedArgs != null) {
			PApplet.main(new Object() {
			}.getClass().getEnclosingClass(), passedArgs);
		} else {
			PApplet.main(new Object() {
			}.getClass().getEnclosingClass());
		}
	}
}
