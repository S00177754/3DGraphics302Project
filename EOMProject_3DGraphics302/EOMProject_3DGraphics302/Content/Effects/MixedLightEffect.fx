#if OPENGL
	#define SV_POSITION POSITION
	#define VS_SHADERMODEL vs_3_0
	#define PS_SHADERMODEL ps_3_0
#else
	#define VS_SHADERMODEL vs_4_0_level_9_1
	#define PS_SHADERMODEL ps_4_0_level_9_1
#endif

matrix World;
matrix View;
matrix Projection;



//Point Light
float3 PointLightPositions[2];
float3 PointLightAttenuations[2];
float3 PointLightColors[2];
float PointLightFallOff = 2; //Inverse square law

//Directional Light
float3 DirectionalLightColor = float3(1, 1, 1);
float3 DirectionalLightDirection = float3(0, 1, 0);

//Common
float3 AmbientColor = float3(.15, .15, .15);
float3 DiffuseColor = float3(1, 1, 1);
texture DiffuseTextures[2];
texture NormalTexture;


//Vertex Shader
struct VertexShaderInput
{
	float4 Position : POSITION0;
	float4 Color : COLOR0;
};

struct VertexShaderOutput
{
	float4 Position : SV_POSITION;
	float4 Color : COLOR0;
};

VertexShaderOutput MainVS(in VertexShaderInput input)
{
	VertexShaderOutput output = (VertexShaderOutput)0;

	//output.Position = mul(input.Position, WorldViewProjection);
	output.Color = input.Color;

	return output;
}

//PixelShader
float4 MainPS(VertexShaderOutput input) : COLOR
{
	return input.Color;
}


technique BasicColorDrawing
{
	pass P0
	{
		VertexShader = compile VS_SHADERMODEL MainVS();
		PixelShader = compile PS_SHADERMODEL MainPS();
	}
};