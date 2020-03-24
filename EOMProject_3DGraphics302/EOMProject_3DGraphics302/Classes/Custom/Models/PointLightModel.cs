using EOMProject_3DGraphics302.Classes.Custom.Materials;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Sample;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EOMProject_3DGraphics302.Classes.Custom.Models
{
    public class PointLightModel : CustomEffectModel
    {
        public PointLightModel(string assetName, Vector3 position) : base(assetName, position)
        {
            Material = new PointLightMaterial()
            {
                LightColor = Color.White,
                Texture = GameUtilities.Content.Load<Texture2D>("Textures/wood4"),
                NormalTexture = GameUtilities.Content.Load<Texture2D>("Textures/WoodNormal"),
                Attenuation = 100,
                Position = new Vector3(0, 10, 10)
            };

            CustomEffect = GameUtilities.Content.Load<Effect>("Effects/MixedLight");
        }

        public override void LoadContent()
        {
            //Instantiatre material, load effect, load additional requirements

            base.LoadContent();
        }
    }
}
