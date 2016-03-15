
modelName = 'meta_tags'

###Model for the table twitter_handles###
module.exports = (sequelize, DataTypes) ->
  MetaTags = sequelize.define(modelName,
    {
      id:
        type: DataTypes.INTEGER
        autoIncrement: true
        primaryKey: true
        allowNull: false

      name:
        type: DataTypes.STRING

  }, {
      tableName: modelName,
      createdAt: "created_at",
      updatedAt: "updated_at",
      deletedAt: "deleted_at",
      timestamps: true,
      paranoid: true,
      classMethods: {
        associate: (models) ->
          MetaTags.hasMany(models.meta_map, {
            foreignKey: 'meta_id'
          })
      },
      indexes: [
        {
          name: 'name_idx',
          unique: true,
          fields: ['name']
        }
      ]
  }
)