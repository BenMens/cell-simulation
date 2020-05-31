import java.awt.geom.Rectangle2D;


class GuiController extends ControllerBase implements BodyModelClient {
    ViewBase parentView;
    BodyModel bodyModel;
    BodyController bodyController;
    ZoomView bodyContainerView;
    CellEditorController cellEditorController;


    GuiController(ControllerBase parentController, ViewBase parentView, BodyModel bodyModel) {
        super(parentController);

        this.parentView = parentView;

        bodyContainerView = new ZoomView(parentView);
        
        bodyController = new BodyController(this, bodyContainerView, bodyModel);

        bodyContainerView.setZoomView(bodyController.bodyView);

        bodyModel.registerClient(this);

        this.updateLayout();
    }

    void beforeLayoutChildren() {
        bodyContainerView.setFrameRect(20, 20, height - 40, height - 40);

        if (this.cellEditorController != null) {
            this.cellEditorController.cellEditorView.setFrameRect(height, 20, width - height - 20, height - 40);
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
}
