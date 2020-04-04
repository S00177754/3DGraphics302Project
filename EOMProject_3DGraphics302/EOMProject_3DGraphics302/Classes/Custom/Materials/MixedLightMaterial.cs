using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Sample;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EOMProject_3DGraphics302.Classes.Custom.Materials
{
    public class MixedLightMaterial : Material
    {
        #region Properties

        public Vector3[] PointLightPositions { get; set; }
        public float[] PointLightAttenuations { get; set; }
        public Color[] PointLightColors { get; set; }

        public Color SpecularColor { get; set; }

        public Color DirectionalLightColor { get; set; }
        public Vector3 DirectionalLightDirection { get; set; }
        public Texture DiffuseTextureOne { get; set; }
        public Texture DiffuseTextureTwo { get; set; }
        public Texture NormalTexture { get; set; }

        public Vector3 CameraPosition { get; set; }

        #endregion

        public override void SetEffectParameters(Effect effect)
        {
            if (effect.Parameters["DirectionalLightColor"] != null)
                effect.Parameters["DirectionalLightColor"].SetValue(DirectionalLightColor.ToVector3());

            if (effect.Parameters["SpecularColor"] != null)
                effect.Parameters["SpecularColor"].SetValue(SpecularColor.ToVector3());

            if (effect.Parameters["DirectionalLightDirection"] != null)
                effect.Parameters["DirectionalLightDirection"].SetValue(DirectionalLightDirection);

            if (effect.Parameters["DiffuseTextureOne"] != null)
                effect.Parameters["DiffuseTextureOne"].SetValue(DiffuseTextureOne);

            if (effect.Parameters["DiffuseTextureTwo"] != null)
                effect.Parameters["DiffuseTextureTwo"].SetValue(DiffuseTextureTwo);

            if (effect.Parameters["NormalTexture"] != null)
                effect.Parameters["NormalTexture"].SetValue(NormalTexture);

            if (effect.Parameters["CameraPosition"] != null)
                effect.Parameters["CameraPosition"].SetValue(CameraPosition);


            if (effect.Parameters["PointLightPositions"] != null)
                effect.Parameters["PointLightPositions"].SetValue(PointLightPositions);

            if (effect.Parameters["PointLightAttenuations"] != null)
                effect.Parameters["PointLightAttenuations"].SetValue(PointLightAttenuations);

            if (effect.Parameters["PointLightColors"] != null)
                effect.Parameters["PointLightColors"].SetValue(PointLightColors.ToVector3());

            base.SetEffectParameters(effect);
        }

        public override void Update()
        {
            //Attenuation Range and Light Position Debug Spheres
            for (int i = 0; i < PointLightPositions.Length; i++)
            {
                DebugEngine.AddBoundingSphere(new BoundingSphere(PointLightPositions[i], PointLightAttenuations[i]), PointLightColors[i]);
                DebugEngine.AddBoundingSphere(new BoundingSphere(PointLightPositions[i], 1f), Color.DarkMagenta);
            }

            //Move Light 1
            if (InputEngine.IsKeyHeld(Keys.Right))
            {
                PointLightPositions[0] += new Vector3(1, 0, 0);
            }
            if (InputEngine.IsKeyHeld(Keys.Down))
            {
                PointLightPositions[0] += new Vector3(0, 0, 1);
            }
            if (InputEngine.IsKeyHeld(Keys.Up))
            {
                PointLightPositions[0] += new Vector3(0, 0, -1);
            }
            if (InputEngine.IsKeyHeld(Keys.Left))
            {
                PointLightPositions[0] += new Vector3(-1, 0, 0);
            }
            if (InputEngine.IsKeyHeld(Keys.PageUp))
            {
                PointLightPositions[0] += new Vector3(0, 1, 0);
            }
            if (InputEngine.IsKeyHeld(Keys.PageDown))
            {
                PointLightPositions[0] += new Vector3(0, -1, 0);
            }

            //Move Light 2
            if (InputEngine.IsKeyHeld(Keys.L))
            {
                PointLightPositions[1] += new Vector3(1, 0, 0);
            }
            if (InputEngine.IsKeyHeld(Keys.K))
            {
                PointLightPositions[1] += new Vector3(0, 0, 1);
            }
            if (InputEngine.IsKeyHeld(Keys.I))
            {
                PointLightPositions[1] += new Vector3(0, 0, -1);
            }
            if (InputEngine.IsKeyHeld(Keys.J))
            {
                PointLightPositions[1] += new Vector3(-1, 0, 0);
            }
            if (InputEngine.IsKeyHeld(Keys.U))
            {
                PointLightPositions[1] += new Vector3(0, 1, 0);
            }
            if (InputEngine.IsKeyHeld(Keys.O))
            {
                PointLightPositions[1] += new Vector3(0, -1, 0);
            }

            base.Update();
        }

        public void UpdateCamera(Vector3 cameraPosition)
        {
            CameraPosition = cameraPosition;
        }

    }

   

    public static class Extensions 
    {
        public static Vector3[] ToVector3(this Color[] clrs)
        {
            Vector3[] vectors = new Vector3[clrs.Length];
            for (int i = 0; i < clrs.Length; i++)
            {
                vectors[i] = clrs[i].ToVector3();
            }

            return vectors;
        }
    }
}
