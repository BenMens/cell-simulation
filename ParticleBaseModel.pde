abstract class ParticleBaseModel implements CellModelClient {
    ArrayList<ParticleModelClient> clients = new ArrayList<ParticleModelClient>();
    BodyModel bodyModel;

    float ticksPerMovementTick = 1;
    float ticksSinceLastMovementTick;

    boolean isDead = false;

    private PVector position = new PVector(0, 0);
    private PVector speed = new PVector(0, 0);

    CellModel previousTouchedCell;
    float cellWallHarmfulness = 0.0003;

    private CellModel containingCell;


    ParticleBaseModel(BodyModel bodyModel) {
        this(bodyModel, random(bodyModel.gridSize.x), random(bodyModel.gridSize.y));
    }
    ParticleBaseModel(BodyModel bodyModel, float positionX, float positionY) {
        this(bodyModel, positionX, positionY, random(0.1) - 0.05, random(0.1) - 0.05);
    }
    ParticleBaseModel(BodyModel bodyModel, float positionX, float positionY, float speedX, float speedY) {
        this.bodyModel = bodyModel;
        this.bodyModel.addParticle(this);

        this.position = new PVector(positionX, positionY);
        this.speed = new PVector(speedX, speedY);
    }


    void registerClient(ParticleModelClient client) {
        if(!clients.contains(client)) {
            clients.add(client);
        }
    }

    void unregisterClient(ParticleModelClient client) {
        clients.remove(client);
    }


    PVector getPosition() {
        return position;
    }

    void setPosition(PVector newPosition) {
        position = newPosition;
    }

    PVector getSpeed() {
        return speed;
    }

    void setSpeed(PVector newSpeed) {
        speed = newSpeed;
    }


    void tick() {
        while (ticksSinceLastMovementTick >= ticksPerMovementTick) {
            movementTick();
            ticksSinceLastMovementTick -= ticksPerMovementTick;
        }
        ticksSinceLastMovementTick++;
    }

    void movementTick() {
        PVector bodySize = bodyModel.gridSize.copy();

        position.add(speed);

        if (position.x < 0) {
            position.x = -position.x;
            speed.x = -speed.x;
        }

        if (position.y < 0) {
            position.y = -position.y;
            speed.y = -speed.y;
        }

        if (position.x > bodySize.x) {
            position.x = 2 * bodySize.x - position.x;
            speed.x = -speed.x;
        }

        if (position.y > bodySize.y) {
            position.y = 2 * bodySize.y - position.y;
            speed.y = -speed.y;
        }

        CellModel currendTouchedCell = findContainingCell();

        if (previousTouchedCell != currendTouchedCell) {

            onCellCollide(currendTouchedCell, previousTouchedCell);

            previousTouchedCell = currendTouchedCell;
        }
    }

    void cleanUpTick() {
        if (isDead) {
            bodyModel.removeParticle(this);
        }
    }

    void setContainingCell(CellModel newContainingCell) {
        if (this.containingCell == newContainingCell) {
            return;
        }

        if (this.containingCell != null) {
            this.containingCell.unregisterClient(this);
            this.containingCell.expelParticle(this);
        } 

        this.containingCell = newContainingCell;

        if (newContainingCell != null) {
            newContainingCell.registerClient(this);
            newContainingCell.receiveParticle(this);
        }
    }

    CellModel getContainingCell() {
        return this.containingCell;
    }


    CellModel findContainingCell() {
        return bodyModel.findCellAtPosition(floor(position.x), floor(position.y));
    }

    abstract String getImageName();

    abstract String getTypeName();

    abstract void onCellCollide(CellModel currendTouchedCell, CellModel previousTouchedCell);

    void onAddCodon(CodonBaseModel codonModel) {};

    void onDestroy(CellModel cellModel) {
        if (containingCell == cellModel) {
            containingCell.expelParticle(this);
            containingCell = null;
        }
    };

    void onRemoveCodon(CodonBaseModel codonModel) {};
}
