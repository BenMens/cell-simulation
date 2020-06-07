import java.awt.geom.Rectangle2D;


class GuiController extends ControllerBase implements BodyModelClient, ButtonViewClient {
    ViewBase parentView;
    BodyModel bodyModel;
    BodyController bodyController;
    ZoomView bodyContainerView;
    CellEditorController cellEditorController;
    ViewBase toolbarView;
    ButtonView playButton;
    ButtonView pauzeButton;


    GuiController(ControllerBase parentController, ViewBase parentView, BodyModel bodyModel) {
        super(parentController);

        this.parentView = parentView;
        this.bodyModel = bodyModel;

        bodyContainerView = new ZoomView(parentView);
        
        bodyController = new BodyController(this, bodyContainerView, bodyModel);

        toolbarView = new ViewBase(parentView);
        toolbarView.shouldClip = true;
        toolbarView.hasBackground = true;
        toolbarView.backgroundColor = color(100, 100, 255);

        playButton = new ButtonView(toolbarView);
        playButton.shouldClip = true;
        playButton.buttonImage = ImageCache.getImage(applet, "images/play-button.png");
        playButton.registerClient(this);

        pauzeButton = new ButtonView(toolbarView);
        pauzeButton.shouldClip = true;
        pauzeButton.buttonImage = ImageCache.getImage(applet, "images/pauze-button.png");
        pauzeButton.registerClient(this);

        bodyContainerView.setZoomView(bodyController.bodyView);

        bodyModel.registerClient(this);

        this.updateLayout();
    }

    void beforeLayoutChildren() {
        Rectangle2D.Float parentRect = this.parentView.getFrameRect();

        toolbarView.setFrameRect(0, 0, parentRect.width, 80);
        toolbarView.setBoundsRect(0, 0, parentRect.width, 80);

        playButton.setFrameRect(parentRect.width - 170, 10, 60, 60);
        pauzeButton.setFrameRect(parentRect.width - 100, 10, 60, 60);

        bodyContainerView.setFrameRect(20, 100, parentRect.height - 120, parentRect.height - 40);

        if (this.cellEditorController != null) {
            this.cellEditorController.cellEditorView.setFrameRect(
                parentRect.height - 80,
                100, 
                parentRect.width - parentRect.height + 60, 
                parentRect.height - 120);
        }
    }

    void onSelectCell(CellModel selectedCell) {
        if (this.cellEditorController != null) {
            this.cellEditorController.destroy();
            this.cellEditorController = null;
        }

        if (selectedCell != null) {
            this.cellEditorController = new CellEditorController(this, parentView, selectedCell);
        }

        this.updateLayout();
    }


    void onAddCell(CellModel cellModel) {}

    void onAddParticle(ParticleBaseModel particleModel) {}

    void onClick(ButtonView button) {
        if (button == pauzeButton) {
            bodyModel.pauzed = true;
        } else if (button == playButton) {
            bodyModel.pauzed = false;
        }

    }

}
