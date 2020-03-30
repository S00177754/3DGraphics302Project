using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MixedLightProject.Classes.Custom
{
    public class MixedLightMaterial:Material
    {
        public Color LightColor { get; set; }
        public Color LightColorTwo { get; set; }
        public Texture2D Texture { get; set; }
        public Texture2D NormalTexture { get; set; }
        public float Attenuation { get; set; }
        public float AttenuationTwo { get; set; }
        public Vector3 Position { get; set; }
        public Vector3 PositionTwo { get; set; }

        public override void SetEffectParameters(Effect effect)
        {
            //color 0 - 255
            //gpu 0 - 1

            if (effect.Parameters["LightColor"] != null)
                effect.Parameters["LightColor"].SetValue(LightColor.ToVector3());

            if (effect.Parameters["Texture"] != null)
                effect.Parameters["Texture"].SetValue(Texture);

            if (effect.Parameters["NormalTexture"] != null)
                effect.Parameters["NormalTexture"].SetValue(NormalTexture);

            if (effect.Parameters["Attenuation"] != null)
                effect.Parameters["Attenuation"].SetValue(Attenuation);

            if (effect.Parameters["Position"] != null)
                effect.Parameters["Position"].SetValue(Position);



            if (effect.Parameters["LightColorTwo"] != null)
                effect.Parameters["LightColorTwo"].SetValue(LightColorTwo.ToVector3());

            if (effect.Parameters["AttenuationTwo"] != null)
                effect.Parameters["AttenuationTwo"].SetValue(AttenuationTwo);

            if (effect.Parameters["PositionTwo"] != null)
                effect.Parameters["PositionTwo"].SetValue(PositionTwo);

            base.SetEffectParameters(effect);
        }
    }
}
